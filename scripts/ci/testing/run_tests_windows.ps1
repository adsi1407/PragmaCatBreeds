<#
Runs module tests and generates coverage files matching CI expectations.

Usage:
  .\run_tests_windows.ps1 -Module all
  .\run_tests_windows.ps1 -Module domain
  .\run_tests_windows.ps1 -Module presentation-widgets
#>

param(
  [Parameter(Mandatory=$true)]
  [ValidateSet('all','domain','infrastructure','presentation-bloc','presentation-widgets')]
  [string]$Module
)

function Run-ModuleTests([string]$workdir, [string]$coverageTarget) {
  Write-Host "Running tests in $workdir"
  Push-Location $workdir
  flutter pub get
  flutter test --coverage --reporter=expanded || Write-Host "Tests finished with non-zero exit"
  if (Test-Path coverage\lcov.info) {
    $dest = Join-Path -Path (Resolve-Path ..) -ChildPath $coverageTarget
    Move-Item -Path coverage\lcov.info -Destination $dest -Force
    Write-Host "Moved coverage to $dest"
  } else {
    Write-Host "No coverage file generated in $workdir"
  }
  Pop-Location
}

switch ($Module) {
  'all' {
    # Domain module
    Run-ModuleTests -workdir "module/domain" -coverageTarget "module/coverage-domain.lcov"

    # Infrastructure module
    Run-ModuleTests -workdir "module/infrastructure" -coverageTarget "module/coverage-infra.lcov"

    # Presentation blocs (root tests under test/presentation/**/bloc)
    Write-Host "Running presentation bloc tests"
    Push-Location .
    flutter pub get
    flutter test --coverage test/presentation/**/bloc -r expanded || Write-Host "Presentation bloc tests finished with non-zero exit"
    if (Test-Path coverage\lcov.info) { Move-Item coverage\lcov.info coverage-presentation-bloc.lcov -Force }
    Pop-Location

    # Presentation widgets
    Write-Host "Running presentation widget tests"
    Push-Location .
    flutter pub get
    flutter test --coverage test/presentation/**/widgets -r expanded || Write-Host "Presentation widget tests finished with non-zero exit"
    if (Test-Path coverage\lcov.info) { Move-Item coverage\lcov.info coverage-presentation-widgets.lcov -Force }
    Pop-Location
  }
  'domain' {
    Run-ModuleTests -workdir "module/domain" -coverageTarget "module/coverage-domain.lcov"
  }
  'infrastructure' {
    Run-ModuleTests -workdir "module/infrastructure" -coverageTarget "module/coverage-infra.lcov"
  }
  'presentation-bloc' {
    Write-Host "Running presentation bloc tests"
    flutter pub get
    flutter test --coverage test/presentation/**/bloc -r expanded || Write-Host "Presentation bloc tests finished with non-zero exit"
    if (Test-Path coverage\lcov.info) { Move-Item coverage\lcov.info coverage-presentation-bloc.lcov -Force }
  }
  'presentation-widgets' {
    Write-Host "Running presentation widget tests"
    flutter pub get
    # Avoid PowerShell glob issues by quoting the path; flutter will handle it
    flutter test --coverage test/presentation/**/widgets -r expanded || Write-Host "Presentation widget tests finished with non-zero exit"
    if (Test-Path coverage\lcov.info) { Move-Item coverage\lcov.info coverage-presentation-widgets.lcov -Force }
  }
}

Write-Host "Done. Check coverage files in the repository root or module folders."
