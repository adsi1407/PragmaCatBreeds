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
        for (final it in (parsed['issues'] as List)) {
          if (it is Map<String, dynamic>) issues.add(it);
        }
      } else if (parsed is List) {
        for (final item in parsed) {
          if (item is Map && item['issues'] is List) {
            for (final it in (item['issues'] as List)) {
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
      // "   info - <message> - <file>:<line> - <rule>"
      // "   error - <message> - <file>:<line> - <rule>"
      // "   warning - <message> - <file>:<line> - <rule>"
      final infoMatch = RegExp(r'^\s*info\s*-').hasMatch(l);
      final errorMatch = RegExp(r'^\s*error\s*-').hasMatch(l);
      final warningMatch = RegExp(r'^\s*warning\s*-').hasMatch(l);
      
      if (errorMatch) {
        txtErrors++;
        if (preview.length < 20) preview.add('ERROR: $l');
      } else if (warningMatch) {
        txtWarnings++;
        if (preview.length < 20) preview.add('WARNING: $l');
      } else if (infoMatch) {
        // Count info messages but don't add to preview to keep it focused
        // We don't fail on info messages
      }
    }

    if (txtErrors == 0 && txtWarnings == 0) {
      // Check if we found any analysis at all
      final hasAnalysisContent = textLines.any((line) => 
        RegExp(r'^\s*(info|warning|error)\s*-').hasMatch(line) ||
        line.contains('issues found') ||
        line.contains('No issues found'));
      
      if (!hasAnalysisContent) {
        stderr.writeln('Could not parse analyze file: no JSON objects found and no analyzer output detected in ${args[0]}');
        return 2;
      }
      
      // If we have analysis content but no errors/warnings, that's success
      stdout.writeln('Analyzer (text) found: errors=0 warnings=0 (only info messages or clean analysis)');
      return 0;
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
