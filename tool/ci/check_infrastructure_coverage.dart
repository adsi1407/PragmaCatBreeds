#!/usr/bin/env dart
// Infrastructure-specific coverage checker.
// Only measures files that infrastructure tests can realistically cover.
// Usage: dart run tool/ci/check_infrastructure_coverage.dart <path-to-lcov.info> <min-percentage>
import 'dart:io';

void main(List<String> args) async {
  if (args.length < 2) {
    stderr.writeln('Usage: dart run tool/ci/check_infrastructure_coverage.dart <lcov.info> <minPercent>');
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
      
      // Infrastructure tests should cover:
      // - Data sources (API, database, local storage)
      // - Repository implementations
      // - DTOs and data models
      // - Network/API clients
      // - Data mappers/translators
      // - Cache implementations
      
      includeCurrent = currentFile.contains('/infrastructure/') ||
                      currentFile.contains('/datasources/') ||
                      currentFile.contains('/datasource/') ||
                      currentFile.contains('/api/') ||
                      currentFile.contains('/network/') ||
                      currentFile.contains('/local/') ||
                      currentFile.contains('/cache/') ||
                      currentFile.contains('/dto/') ||
                      currentFile.contains('/models/') ||
                      currentFile.contains('/translator/') ||
                      currentFile.contains('/mapper/') ||
                      currentFile.endsWith('_api.dart') ||
                      currentFile.endsWith('_dto.dart') ||
                      currentFile.endsWith('_model.dart') ||
                      currentFile.endsWith('_repository_impl.dart') ||
                      currentFile.endsWith('_datasource.dart') ||
                      currentFile.endsWith('_translator.dart');
      
      // Exclude UI, domain logic, generated files
      if (currentFile.endsWith('.g.dart') || 
          currentFile.contains('/generated/') || 
          currentFile.contains('/.dart_tool/') ||
          currentFile.contains('/presentation/') ||
          currentFile.contains('/l10n/') ||
          currentFile.contains('/widgets/') ||
          currentFile.contains('/pages/') ||
          currentFile.contains('/bloc/') ||
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
  
  print('Infrastructure Coverage Report:');
  print('==============================');
  print('Lines covered: $coveredLines');
  print('Total lines: $totalLines');
  print('Coverage: ${percent.toStringAsFixed(1)}%');
  print('Required: ${minPercent.toStringAsFixed(1)}%');
  
  if (percent >= minPercent) {
    print('✅ Infrastructure coverage check PASSED');
    exit(0);
  } else {
    print('❌ Infrastructure coverage check FAILED');
    print('Coverage ${percent.toStringAsFixed(1)}% is below required ${minPercent.toStringAsFixed(1)}%');
    exit(1);
  }
}