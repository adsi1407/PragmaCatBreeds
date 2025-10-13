# SonarCloud Integration Guide

````markdown
# SonarCloud Integration Guide

## Overview
This guide explains how SonarCloud is integrated into the Pragma Cat Breeds project and how the CI pipeline produces coverage and module-aware analysis.
### 1. Configure SonarCloud
1. Go to https://sonarcloud.io
2. Sign in with your GitHub account
3. Import the repository `adsi1407/PragmaCatBreeds`
4. Set the organization to `adsi1407`

### 2. Add GitHub Secrets
In your repository settings → Secrets and variables → Actions add:
```
SONAR_TOKEN: <your-sonar-token>
```

### 3. Quality Gates
SonarCloud will enforce Quality Gates that may fail the CI when:
- Maintainability, Reliability or Security ratings drop below acceptable thresholds
- Coverage is below configured thresholds
- Duplicated lines exceed the configured limit

## Metrics monitored

### Technical Debt Ratio
- What it measures: estimated time to fix issues vs development time
- Recommended threshold: ≤ 5%

### Maintainability Rating
- A: ≤ 5% technical debt ratio
- B: 6-10% technical debt ratio
- C: 11-20% technical debt ratio
- D: 21-50% technical debt ratio
- E: > 50% technical debt ratio

### Code Smells
- Issues affecting maintainability
- Categorized by severity: Blocker, Critical, Major, Minor, Info

### Duplication
- Recommended threshold: ≤ 3% duplicated lines

## CI/CD integration

### Pull Request Decoration
SonarCloud will:
- Analyze PR changes
- Comment issues on the PR
- Block merges if Quality Gate fails
- Display coverage metrics in the PR

### Branch Analysis
- Main branch: full analysis with historical trending
- Feature branches: differential analysis vs main

### Note about the `presentation` layer
In this repository `presentation` is analyzed as part of the root `lib/` sources (it is not a separate Sonar module). The CI pipeline generates LCOVs by category (BLoC, widgets, pages) and combines them into `coverage/combined.lcov` which Sonar consumes during analysis. This avoids reorganizing the repository and keeps coverage reporting centralized.

If you later decide you need `presentation` as an independent Sonar module, two approaches are available:

- Quick (less robust): set `presentation.sonar.projectBaseDir=lib/src/presentation` in `sonar-project.properties` and adjust test and coverage paths relative to that baseDir.
- Robust (recommended): create a temporary `presentation/` folder in the CI runner before the Sonar scan and copy `lib/src/presentation` → `presentation/lib` and `test/presentation` → `presentation/test`. This preserves the repo structure while allowing Sonar to see a module layout it expects.

Current pipeline choice: we analyze `presentation` as part of `lib/` and use combined coverage.

### Pipeline coverage properties (what and why)

To make SonarCloud show coverage produced by CI, the project config and the GitHub Actions job follow two simple ideas:

- Produce LCOVs per logical unit (modules and presentation categories) and combine/filter them into `coverage/filtered.lcov`, or pass module-level LCOVs directly.
- Tell the Sonar scanner where the LCOVs live using the properties recognized by the Dart coverage sensor.

Important properties and examples:

- In `sonar-project.properties` (recommended for persistent values):

```properties
# Sources: avoid including the top-level `module` folder if each module defines a projectBaseDir
sonar.sources=lib

# Modules (projectBaseDir relative to repo root)
domain.sonar.projectBaseDir=module/domain
domain.sonar.sources=lib
domain.sonar.tests=test

infrastructure.sonar.projectBaseDir=module/infrastructure
infrastructure.sonar.sources=lib
infrastructure.sonar.tests=test

# Tell the Dart sensor where to find LCOVs (paths relative to each projectBaseDir for modules)
sonar.dart.lcov.reportPaths=coverage/filtered.lcov
domain.sonar.dart.lcov.reportPaths=coverage/lcov.info
infrastructure.sonar.dart.lcov.reportPaths=coverage/lcov.info
```

- In the GitHub Actions step that invokes the scanner you can also pass explicit arguments (useful for temporary or per-run overrides):

```yaml
with:
  args: >
    -Dsonar.organization=adsi1407
    -Dsonar.projectKey=adsi1407_PragmaCatBreeds
  -Dsonar.token=${{ secrets.SONAR_TOKEN }}
    -Dsonar.dart.lcov.reportPaths=module/domain/coverage/lcov.info,module/infrastructure/coverage/lcov.info,coverage/filtered.lcov
    -Dsonar.verbose=true
```

Technical notes and best practices:

- `sonar.dart.lcov.reportPaths` (project-level property) is what activates the Dart coverage sensor. Passing module-relative LCOV paths (relative to each module's `projectBaseDir`) helps Sonar map coverage to the correct source files.
- Avoid including the `module` folder at the root `sonar.sources` if you declare modules with `projectBaseDir` — otherwise Sonar can index the same files twice and you will see "File can't be indexed twice" errors.
- You can pass multiple LCOV files (comma-separated) either in `sonar-project.properties` or via `-D` when invoking the scanner. The current pipeline provides both module LCOVs and a combined `coverage/filtered.lcov` for redundancy.
- If you generate `coverage/filtered.lcov` with `lcov --remove`, make sure the `SF:` (source file) entries in the LCOV match the paths Sonar indexed (for example `lib/...` vs `module/domain/lib/...`). Path mismatches prevent Sonar from assigning coverage.
- The CI job that runs the scanner must have access to the `SONAR_TOKEN` secret (not available to workflows from forks) and to the LCOV files in the workspace.

With this setup the scanner should load the LCOVs and reflect module and overall coverage in SonarCloud.


## Advanced configuration

### Custom Quality Gates
You can define custom gates for stricter checks, for example:
```yaml
Conditions:
- Maintainability Rating is worse than A
- Reliability Rating is worse than A
- Security Rating is worse than A
- Coverage on New Code is less than 80%
- Duplicated Lines (%) on New Code is greater than 3%
- Technical Debt Ratio on New Code is greater than 5%
```

### Exclusions
Configured in `sonar-project.properties`:
- Generated files (*.g.dart, *.freezed.dart)
- Config files
- Platform folders (android/, ios/, etc.)
- Test files (coverage handled separately)

## Dashboards and reports

### Project Dashboard
- Overview of code health
- Historical trends
- Breakdown by issue type

### Security Hotspots
- Automatic detection of potential vulnerabilities
- Prioritization by impact

### Maintainability
- Breakdown of code smells
- Estimated effort for fixes
- Cyclomatic complexity metrics

## Useful commands

### Local analysis
```bash
# Install SonarScanner
npm install -g sonarqube-scanner

# Run local analysis
sonar-scanner \
  -Dsonar.projectKey=adsi1407_PragmaCatBreeds \
  -Dsonar.organization=adsi1407 \
  -Dsonar.sources=. \
  -Dsonar.host.url=https://sonarcloud.io \
  -Dsonar.token=your_token
```

### Generate coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Benefits vs custom scripts

### ✅ Advantages of SonarCloud
- Zero maintenance on the analysis platform
- Standardized metrics
- Professional dashboards
- Historical trending
- Native GitHub integration
- Automatic notifications and security checks

### Minimal configuration
- One config file (`sonar-project.properties`)
- One GitHub Actions workflow

## Next steps

1. Add `SONAR_TOKEN` to GitHub secrets
2. Push a branch or PR to trigger the SonarCloud workflow
3. Review module/coverage results in SonarCloud and adjust gates as needed

Do you want to keep the current approach (presentation in `lib/`) or switch to a module-based setup?