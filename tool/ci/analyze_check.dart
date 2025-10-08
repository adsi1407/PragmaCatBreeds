// Script: tool/ci/analyze_check.dart
// Usage: dart run tool/ci/analyze_check.dart analyze.json

import 'dart:convert';
import 'dart:io';

Future<int> main(List<String> args) async {
  if (args.isEmpty) {
    stderr.writeln('Usage: analyze_check.dart <analyze_json_file>');
    return 2;
  }
  final file = File(args[0]);
  if (!await file.exists()) {
    stderr.writeln('File not found: ${args[0]}');
    return 2;
  }

  final content = await file.readAsString();

  // flutter analyze --format=json may output multiple JSON objects separated by newlines.
  // We'll parse line-by-line and attempt to decode any JSON object/array found.
  final issues = <Map<String, dynamic>>[];
  bool parsedAnything = false;

  final lines = content.split(RegExp(r'\r?\n'));
  for (final raw in lines) {
    final l = raw.trim();
    if (l.isEmpty) continue;
    // Try parsing this line as JSON. If it fails, skip it.
    try {
      final parsed = jsonDecode(l);
      parsedAnything = true;
      if (parsed is Map && parsed['issues'] is List) {
        for (final it in parsed['issues']) {
          if (it is Map<String, dynamic>) issues.add(it);
        }
      } else if (parsed is List) {
        for (final item in parsed) {
          if (item is Map && item['issues'] is List) {
            for (final it in item['issues']) {
              if (it is Map<String, dynamic>) issues.add(it);
            }
          }
        }
      }
    } catch (_) {
      // ignore non-JSON lines
      continue;
    }
  }

  if (!parsedAnything) {
    // Fallback: try to parse plain-text analyzer output (non-JSON) and look for
    // lines that indicate errors/warnings. This makes the script robust across
    // different Flutter versions where --format/json may not be available.
    final textLines = content.split(RegExp(r'\r?\n'));
    var txtErrors = 0;
    var txtWarnings = 0;
    final preview = <String>[];
    for (final ln in textLines) {
      final l = ln.trim();
      if (l.isEmpty) continue;
      // Common analyzer textual output includes patterns like:
      // "error • <message> • <file>:<line>"
      final isError = RegExp(r'^error\b', caseSensitive: false).hasMatch(l) || l.contains(' • error • ');
      final isWarning = RegExp(r'^warning\b', caseSensitive: false).hasMatch(l) || l.contains(' • warning • ');
      if (isError) {
        txtErrors++;
        if (preview.length < 20) preview.add('ERROR: $l');
      } else if (isWarning) {
        txtWarnings++;
        if (preview.length < 20) preview.add('WARNING: $l');
      }
    }

    if (txtErrors == 0 && txtWarnings == 0) {
      stderr.writeln('Could not parse analyze JSON file: no JSON objects found and no textual analyzer markers in ${args[0]}');
      return 2;
    }

    // Print summary based on textual parsing
    stdout.writeln('Analyzer (text) found: errors=$txtErrors warnings=$txtWarnings info=0 total=${txtErrors + txtWarnings}');
    if (preview.isNotEmpty) {
      stdout.writeln('\nAnalyzer preview (textual matches):');
      for (final p in preview) {
        stdout.writeln(' - $p');
      }
    }
    if (txtErrors > 0) {
      stderr.writeln('Failing CI because analyzer reported $txtErrors error(s).');
      return 1;
    }
    return 0;
  }

  var errors = 0;
  var warnings = 0;
  var infos = 0;
  for (final it in issues) {
    final severity = (it['severity'] ?? '').toString().toLowerCase();
    if (severity == 'error') errors++;
    if (severity == 'warning') warnings++;
    if (severity == 'info') infos++;
  }

  stdout.writeln('Analyzer found: errors=$errors warnings=$warnings info=$infos total=${issues.length}');

  // Print a short table of first few issues
  final preview = issues.take(10).toList();
  for (final it in preview) {
    final filePath = it['location']?['file'] ?? it['file'] ?? '<unknown>';
    final line = it['location']?['range']?['start']?['line'] ?? it['line'] ?? '?';
    final message = it['message'] ?? it['problemMessage'] ?? it['messageText'] ?? '';
    final sev = it['severity'] ?? '';
    stdout.writeln(' - ${sev.toString().toUpperCase()} $filePath:$line: $message');
  }

  if (errors > 0) {
    stderr.writeln('Failing CI because analyzer reported $errors error(s).');
    return 1;
  }

  // exit 0 if only warnings/infos
  return 0;
}
