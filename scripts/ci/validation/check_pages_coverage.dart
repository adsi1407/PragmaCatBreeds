#!/usr/bin/env dart
// Pages-specific coverage checker.
// Only measures files that page tests can realistically cover.
// Usage: dart run scripts/ci/validation/check_pages_coverage.dart <path-to-lcov.info> <min-percentage>
import 'dart:io';

void main(List<String> args) async {
  if (args.length < 2) {
    stderr.writeln('Usage: dart run scripts/ci/validation/check_pages_coverage.dart <lcov.info> <minPercent>');
    exit(2);
  }

  final path = args[0];
  final minPercent = double.tryParse(args[1]) ?? 0.0;

  final file = File(path);
  if (!await file.exists()) {
    stderr.writeln('Coverage file not found: $path');
    exit(2);
  }

  final lines = await file.readAsLines();
  int totalLines = 0;
  int coveredLines = 0;

  String? currentFile;
  bool includeCurrent = false;

  for (final line in lines) {
    if (line.startsWith('SF:')) {
      currentFile = line.substring(3).replaceAll('\\', '/');
      
      // Page tests should cover:
      // - Page widgets and their rendering
      // - Page navigation logic
      // - Page-level state management
      // - Page-specific UI behaviors
      // - Route configurations (if any)
      
      includeCurrent = currentFile.contains('/page/') ||
                      currentFile.contains('/pages/') ||
                      currentFile.endsWith('_page.dart') ||
                      currentFile.endsWith('_screen.dart') ||
                      (currentFile.contains('/presentation/') && 
                       !currentFile.contains('/bloc/') && 
                       !currentFile.contains('/widgets/'));
      
      // Exclude BLoCs, widgets, APIs, domain, infrastructure, etc.
      if (currentFile.endsWith('.g.dart') || 
          currentFile.contains('/generated/') || 
          currentFile.contains('/.dart_tool/') ||
          currentFile.contains('/bloc/') ||
          currentFile.contains('/widgets/') ||
          currentFile.contains('/domain/') ||
          currentFile.contains('/infrastructure/') ||
          currentFile.contains('/api/') ||
          currentFile.contains('/l10n/') ||
          currentFile.contains('/theme/') ||
          currentFile.endsWith('/main.dart') ||
          currentFile.contains('/dependency_injection/')) {
        includeCurrent = false;
      }
    }

    if (!includeCurrent) {
      continue;
    }

    if (line.startsWith('LF:')) {
      final value = int.tryParse(line.substring(3)) ?? 0;
      totalLines += value;
    } else if (line.startsWith('LH:')) {
      final value = int.tryParse(line.substring(3)) ?? 0;
      coveredLines += value;
    }
  }

  final percent = totalLines == 0 ? 0.0 : (coveredLines / totalLines) * 100.0;
  
  print('Pages Coverage Report:');
  print('=====================');
  print('Lines covered: $coveredLines');
  print('Total lines: $totalLines');
  print('Coverage: ${percent.toStringAsFixed(1)}%');
  print('Required: ${minPercent.toStringAsFixed(1)}%');
  
  if (percent >= minPercent) {
    print('✅ Pages coverage check PASSED');
    exit(0);
  } else {
    print('❌ Pages coverage check FAILED');
    print('Coverage ${percent.toStringAsFixed(1)}% is below required ${minPercent.toStringAsFixed(1)}%');
    exit(1);
  }
}