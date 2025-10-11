# Security and Quality Pipeline Documentation

## 🛡️ **OWASP Security Integration**

This project now includes comprehensive OWASP security tools integrated into the CI/CD pipeline:

### **OWASP Dependency-Check**
- **Purpose**: Scans all dependencies (Flutter packages, GitHub Actions) for known vulnerabilities (CVEs)
- **Frequency**: Every push, PR, and weekly scheduled scans
- **Reports**: Detailed JSON/HTML reports uploaded as artifacts

### **OWASP MobSF (Mobile Security Framework)**
- **Purpose**: Analyzes compiled APK for mobile-specific security vulnerabilities
- **Scope**: Security configuration, permissions, hardcoded secrets, binary analysis
- **Output**: Security score and detailed findings report

## 📊 **Modular SonarCloud Configuration**

### **Module Structure**
The project uses a modular architecture with SonarCloud configured to respect this structure:

```
├── lib/src/presentation/     # Presentation Layer (BLoC pattern)
├── module/domain/           # Domain Layer (Clean Architecture)
└── module/infrastructure/   # Infrastructure Layer (External dependencies)
```

### **Coverage Thresholds by Module**
- **Domain Layer**: ≥90% (Critical business logic)
- **Infrastructure Layer**: ≥60% (External integrations)
- **Presentation BLoC**: ≥50% (State management)
- **Presentation Widgets**: ≥40% (UI components)

### **Running Modular Coverage**
```bash
# Use the enhanced script for SonarCloud-compatible coverage
./scripts/sonar_coverage.sh

# Or run individual module tests
flutter test --coverage                    # Main app
cd module/domain && flutter test --coverage    # Domain layer
cd module/infrastructure && flutter test --coverage  # Infrastructure layer
```

## 🤖 **Dependabot Management**

### **Automated PR Handling**
- **Patch updates**: Auto-merged after all checks pass
- **Minor updates**: Manual review required, but can be approved with `@dependabot merge`
- **Major updates**: Always require manual review

### **PR Commands**
- `@dependabot retry` - Retry failed checks
- `@dependabot pause` - Pause auto-merge for review
- `@dependabot merge` - Force merge after manual review
- `@dependabot rebase` - Rebase the PR

### **Schedule**
- **Main dependencies**: Monday 9:00 AM
- **Domain module**: Monday 10:00 AM  
- **Infrastructure module**: Monday 11:00 AM
- **GitHub Actions**: Tuesday 9:00 AM

## 🚀 **Pipeline Overview**

### **On Every Push/PR**
1. **OWASP Dependency Check** - Vulnerability scanning
2. **SonarCloud Analysis** - Code quality and modular coverage
3. **CodeQL Analysis** - Static security analysis
4. **Gitleaks** - Secret detection
5. **Semgrep** - Additional security patterns

### **Mobile Security (PR/Push)**
1. **Build APK** with test configuration
2. **MobSF Analysis** for mobile-specific vulnerabilities
3. **Security score** and findings report

### **Weekly Automated**
1. **OWASP scans** for updated vulnerability database
2. **Dependabot updates** for all modules
3. **Dependency security review**

## 📋 **Quality Gates**

### **Required for Merge**
- ✅ All security scans pass (no high/critical vulnerabilities)
- ✅ SonarCloud quality gate passes
- ✅ Coverage thresholds met by module
- ✅ No secrets detected
- ✅ CodeQL analysis clean

### **PR Comments**
All workflows provide automated comments with:
- Security findings summary
- Coverage reports by module
- Dependabot analysis and recommendations
- Direct links to detailed reports

## 🎯 **Best Practices**

### **For Developers**
1. Run `./scripts/sonar_coverage.sh` before committing
2. Review Dependabot PRs promptly
3. Address security findings immediately
4. Maintain module-specific coverage thresholds

### **For Security**
1. Monitor weekly OWASP reports
2. Review MobSF findings for mobile-specific issues
3. Keep dependencies updated through Dependabot
4. Regularly check SonarCloud security hotspots

## 🔧 **Troubleshooting**

### **Common Issues**
- **Coverage not generated**: Ensure all modules have `flutter pub get`
- **SonarCloud module errors**: Check `sonar-project.properties` module configuration
- **Dependabot conflicts**: Use `@dependabot rebase` to resolve
- **Security scan failures**: Check artifacts for detailed reports

### **Manual Overrides**
- Comment `@dependabot retry` to re-run checks on Dependabot PRs
- Use `/retry` in PR comments to retrigger failed workflows
- Skip security scans with `[skip security]` in commit message (not recommended)

## 📈 **Monitoring**

### **Dashboards**
- [SonarCloud Project](https://sonarcloud.io/project/overview?id=adsi1407_PragmaCatBreeds)
- [GitHub Security Tab](https://github.com/adsi1407/PragmaCatBreeds/security)
- [Dependency Graph](https://github.com/adsi1407/PragmaCatBreeds/network/dependencies)

### **Notifications**
- Security vulnerabilities trigger immediate notifications
- Coverage drops below thresholds block PR merges
- Weekly digest of dependency updates and security status