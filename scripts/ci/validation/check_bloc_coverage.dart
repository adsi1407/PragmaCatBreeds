#!/usr/bin/env dart
// Filtered coverage checker for BLoC tests only.
// This script filters lcov to only include files that BLoC tests can realistically cover.
// Usage: dart run scripts/ci/validation/check_bloc_coverage.dart <path-to-lcov.info> <min-percentage>
import 'dart:io';

void main(List<String> args) async {
  if (args.length < 2) {
    stderr.writeln('Usage: dart run scripts/ci/validation/check_bloc_coverage.dart <lcov.info> <minPercent>');
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

  // Track current source file to allow filtering to BLoC-related files only
  String? currentFile;
  bool includeCurrent = false;

  for (final line in lines) {
    if (line.startsWith('SF:')) {
      currentFile = line.substring(3).replaceAll('\\', '/');
      
      // Only include files that BLoC tests can realistically cover:
      // - BLoC files themselves (bloc/, events/, states/)
      // - Domain entities and use cases (if they exist and are used by BLoC)
      // - Models/DTOs that BLoC processes
      
      includeCurrent = currentFile.contains('/bloc/') ||
                      currentFile.contains('/events/') ||
                      currentFile.contains('/states/') ||
                      currentFile.endsWith('_bloc.dart') ||
                      currentFile.endsWith('_event.dart') ||
                      currentFile.endsWith('_state.dart');
      
      // Exclude generated files and common non-BLoC files
      if (currentFile.endsWith('.g.dart') || 
          currentFile.contains('/generated/') || 
          currentFile.contains('/.dart_tool/') ||
          currentFile.contains('/l10n/') ||
          currentFile.contains('/page/') ||
          currentFile.contains('/widgets/') ||
          currentFile.contains('/theme/') ||
          currentFile.endsWith('/main.dart') ||
          currentFile.contains('/dependency_injection/')) {
        includeCurrent = false;
      }
    }

    if (!includeCurrent) {
      // Skip LF/LH entries for excluded files
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
  
  print('BLoC Coverage Report:');
  print('===================');
  print('Lines covered: $coveredLines');
  print('Total lines: $totalLines');
  print('Coverage: ${percent.toStringAsFixed(1)}%');
  print('Required: ${minPercent.toStringAsFixed(1)}%');
  
  if (percent >= minPercent) {
    print('✅ BLoC coverage check PASSED');
    exit(0);
  } else {
    print('❌ BLoC coverage check FAILED');
    print('Coverage ${percent.toStringAsFixed(1)}% is below required ${minPercent.toStringAsFixed(1)}%');
    exit(1);
  }
}