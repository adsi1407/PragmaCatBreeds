#!/usr/bin/env dart
// Domain-specific coverage checker.
// Only measures files that domain tests can realistically cover.
// Usage: dart run tool/ci/check_domain_coverage.dart <path-to-lcov.info> <min-percentage>
import 'dart:io';

void main(List<String> args) async {
  if (args.length < 2) {
    stderr.writeln('Usage: dart run tool/ci/check_domain_coverage.dart <lcov.info> <minPercent>');
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
      
      // Domain tests should only cover:
      // - Domain entities and value objects
      // - Use cases and business logic
      // - Domain repositories (interfaces)
      // - Domain exceptions
      
      includeCurrent = currentFile.contains('/domain/') ||
                      currentFile.contains('/entities/') ||
                      currentFile.contains('/use_cases/') ||
                      currentFile.contains('/use_case/') ||
                      currentFile.contains('/repositories/') ||
                      currentFile.contains('/repository/') ||
                      currentFile.contains('/exceptions/') ||
                      currentFile.contains('/value_objects/') ||
                      currentFile.endsWith('_entity.dart') ||
                      currentFile.endsWith('_use_case.dart') ||
                      currentFile.endsWith('_repository.dart') ||
                      currentFile.endsWith('_exception.dart');
      
      // Always exclude generated files, UI, infrastructure
      if (currentFile.endsWith('.g.dart') || 
          currentFile.contains('/generated/') || 
          currentFile.contains('/.dart_tool/') ||
          currentFile.contains('/presentation/') ||
          currentFile.contains('/infrastructure/') ||
          currentFile.contains('/l10n/') ||
          currentFile.contains('/api/') ||
          currentFile.contains('/widgets/') ||
          currentFile.contains('/pages/') ||
          currentFile.contains('/bloc/')) {
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
  
  print('Domain Coverage Report:');
  print('======================');
  print('Lines covered: $coveredLines');
  print('Total lines: $totalLines');
  print('Coverage: ${percent.toStringAsFixed(1)}%');
  print('Required: ${minPercent.toStringAsFixed(1)}%');
  
  if (percent >= minPercent) {
    print('✅ Domain coverage check PASSED');
    exit(0);
  } else {
    print('❌ Domain coverage check FAILED');
    print('Coverage ${percent.toStringAsFixed(1)}% is below required ${minPercent.toStringAsFixed(1)}%');
    exit(1);
  }
}