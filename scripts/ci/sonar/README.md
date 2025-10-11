# SonarCloud Integration Scripts

All scripts related to SonarCloud setup, configuration, and specialized coverage generation.

## 📁 Available Scripts

### `setup_sonarcloud.sh` (Linux/macOS/WSL)
Complete SonarCloud integration setup and configuration.

### `setup_sonarcloud.ps1` (Windows PowerShell)
Windows version of SonarCloud setup and configuration.

### `sonar_coverage.sh` (Linux/macOS/WSL)
Specialized coverage generation optimized for SonarCloud analysis.

## 🎯 Features

### SonarCloud Setup (`setup_sonarcloud.*`)
- **Configuration validation**: Verifies sonar-project.properties
- **Workflow verification**: Checks GitHub Actions workflow exists
- **Token setup**: Guides through SONAR_TOKEN configuration
- **Project binding**: Connects local project to SonarCloud
- **Integration testing**: Validates the complete setup

### SonarCloud Coverage (`sonar_coverage.sh`)
- **Modular coverage**: Generates coverage per architectural layer
- **SonarCloud optimization**: Format and structure optimized for SonarCloud
- **Threshold validation**: Uses SonarCloud-specific coverage thresholds
- **Quality gate preparation**: Prepares reports for SonarCloud quality gates

## 🚀 Usage

### Initial SonarCloud Setup
```bash
# Linux/macOS/WSL
./scripts/sonar/setup_sonarcloud.sh

# Windows PowerShell
.\scripts\sonar\setup_sonarcloud.ps1

# This will:
# 1. Validate configuration files
# 2. Guide through token setup
# 3. Test SonarCloud integration
# 4. Verify project binding
```

### Generate SonarCloud Coverage
```bash
# Linux/macOS/WSL
./scripts/sonar/sonar_coverage.sh

# This will:
# 1. Generate modular coverage reports
# 2. Apply SonarCloud-specific formatting
# 3. Validate against quality gate thresholds
# 4. Prepare artifacts for SonarCloud analysis
```

## 📊 Coverage Thresholds

SonarCloud-specific coverage requirements:
- **Domain Module**: 90% coverage (business logic focus)
- **Infrastructure Module**: 60% coverage (external dependencies)
- **Presentation BLoC**: 50% coverage (state management)
- **Presentation Widgets**: 40% coverage (UI components)

## 🔧 Prerequisites

### For Setup Scripts
- **SonarCloud account**: With project created
- **GitHub repository**: Connected to SonarCloud
- **SONAR_TOKEN**: Generate from SonarCloud account settings
- **Project configuration**: sonar-project.properties file

### For Coverage Scripts
- **Flutter SDK**: For test execution
- **Project dependencies**: All modules must have dependencies installed
- **SonarCloud project**: Must be properly configured

## 🔗 Integration

These scripts integrate with:
- **GitHub Actions**: CI/CD SonarCloud workflows
- **Quality Gates**: Automated quality validation
- **Code Coverage**: Integration with coverage tools
- **Static Analysis**: Code quality metrics and reporting

## 🛠️ Troubleshooting

### Common Issues
1. **Token authentication**: Verify SONAR_TOKEN permissions
2. **Project binding**: Ensure project exists in SonarCloud
3. **Coverage format**: Check lcov file generation
4. **Network connectivity**: Verify SonarCloud API access

### Configuration Files
- `sonar-project.properties`: Project configuration
- `.github/workflows/sonarcloud.yml`: CI/CD integration
- Coverage reports: Generated in `coverage/` directories