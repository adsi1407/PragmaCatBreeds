# 👀 Code Review Guidelines

This guide provides **reviewers** with comprehensive checklists and best practices for reviewing Pull Requests efficiently and effectively.

## 🎯 **Review Philosophy**

### **Automation-First Approach**
**The reviewer should NOT manually verify things that tools can check automatically.** Instead:
- ✅ **Verify tools ran successfully** (CI checks, coverage, linting)
- ✅ **Review tool outputs** for meaningful insights  
- ✅ **Focus on human judgment** (architecture, logic, business requirements)

### **What Tools Handle vs What Reviewers Do**

| 🤖 **Automated by Tools** | 👤 **Reviewer Focus** |
|---------------------------|------------------------|
| Code formatting (`flutter format`) | Architecture decisions |
| Static analysis (`flutter analyze`) | Business logic correctness |
| Test coverage thresholds | Test quality and edge cases |
| Dependency vulnerabilities (OWASP) | Security design patterns |
| Code quality metrics (SonarCloud) | Code readability and maintainability |
| Golden test validation | UI/UX design decisions |

---

# 📋 **PR Type-Specific Checklists**

## 🎁 **Feature PR Reviews**

### **Pre-Review: Verify Automation**
- [ ] ✅ **CI Pipeline**: All checks pass (domain ≥90%, infrastructure ≥60%, presentation ≥50%)
- [ ] ✅ **SonarCloud**: Quality gates pass, no new vulnerabilities
- [ ] ✅ **OWASP**: Security scans complete, no high-severity issues
- [ ] ✅ **Static Analysis**: `flutter analyze` passes without errors
- [ ] ✅ **Formatting**: Code is properly formatted
- [ ] ✅ **Golden Tests**: Updated if UI changes detected

### **Architecture Review**
- [ ] **Clean Architecture compliance**: New feature follows Domain/Infrastructure/Presentation layers
- [ ] **SOLID principles**: Single responsibility maintained, dependencies properly injected
- [ ] **Feature organization**: Related code grouped logically within appropriate modules
- [ ] **API contracts**: New interfaces well-defined and documented
- [ ] **State management**: BLoC patterns used correctly for business logic

### **Business Logic Review**
- [ ] **Requirements fulfillment**: Feature addresses all acceptance criteria
- [ ] **Edge case handling**: Error scenarios properly managed
- [ ] **Data flow**: Information flows correctly through all layers
- [ ] **User experience**: Feature integrates smoothly with existing flows
- [ ] **Performance impact**: No obvious performance bottlenecks introduced

### **Testing Strategy**
- [ ] **Test completeness**: New behavior has appropriate test coverage
- [ ] **Test quality**: Tests verify actual business behavior, not just implementation
- [ ] **Integration testing**: Feature works with existing components
- [ ] **Error handling tests**: Failure scenarios are tested

---

## 🐛 **Bug Fix PR Reviews**

### **Pre-Review: Verify Automation**
- [ ] ✅ **CI Pipeline**: All checks pass, coverage maintained
- [ ] ✅ **Regression Tests**: Existing tests still pass
- [ ] ✅ **Static Analysis**: No new warnings introduced

### **Root Cause Analysis**
- [ ] **Problem identification**: Root cause clearly understood and documented
- [ ] **Fix scope**: Solution addresses cause, not just symptoms
- [ ] **Side effects**: Fix doesn't introduce new issues
- [ ] **Similar issues**: Check if same pattern exists elsewhere

### **Fix Quality**
- [ ] **Minimal impact**: Smallest possible change to fix issue
- [ ] **Backwards compatibility**: Existing functionality preserved
- [ ] **Error handling**: Better error handling prevents recurrence
- [ ] **Logging/monitoring**: Adequate visibility for future debugging

### **Prevention Strategy**
- [ ] **Test addition**: New test prevents regression
- [ ] **Documentation update**: If bug was due to unclear behavior
- [ ] **Process improvement**: Consider if development process needs adjustment

---

## 🚀 **Deploy PR Reviews**

### **Pre-Review: Verify Automation**
- [ ] ✅ **All Pipelines**: CI, SonarCloud, OWASP all green
- [ ] ✅ **Version Consistency**: Version numbers properly updated
- [ ] ✅ **Changelog**: Updated with all changes since last release

### **Deployment Safety**
- [ ] **Environment configuration**: Correct settings for target environment
- [ ] **Database migrations**: Safe and reversible if applicable
- [ ] **Feature flags**: Properly configured for gradual rollout
- [ ] **Rollback plan**: Clear strategy if deployment fails
- [ ] **Monitoring setup**: Adequate observability for new release

### **Release Readiness**
- [ ] **Documentation**: User-facing changes documented
- [ ] **Performance testing**: Load testing completed if applicable
- [ ] **Security review**: Additional security validation for sensitive changes
- [ ] **Stakeholder approval**: Required approvals obtained

---

## 📦 **Release PR Reviews**

### **Pre-Review: Verify Automation**
- [ ] ✅ **Full Test Suite**: All test categories pass (unit, integration, smoke, theme)
- [ ] ✅ **Coverage Compliance**: All modules meet coverage thresholds
- [ ] ✅ **Security Scans**: Comprehensive security validation complete

### **Release Coordination**
- [ ] **Version strategy**: Semantic versioning correctly applied
- [ ] **Release notes**: Comprehensive and user-friendly
- [ ] **Breaking changes**: Clearly documented with migration guide
- [ ] **Dependencies**: All dependencies up-to-date and secure
- [ ] **Platform compatibility**: Tested on target platforms

### **Quality Assurance**
- [ ] **Integration testing**: End-to-end scenarios validated
- [ ] **Performance benchmarks**: No performance degradation
- [ ] **Accessibility compliance**: UI changes meet accessibility standards
- [ ] **Localization**: All user-facing text properly localized

---

# 🛠️ **Reviewer Tools & Commands**

## **Quick Verification Commands**
```bash
# Verify CI-like environment locally
./scripts/dev/cleanup/clean_project_working.ps1
flutter pub get

# Check coverage like CI does
dart run scripts/ci/validation/check_coverage.dart module/domain/coverage/lcov.info 90
dart run scripts/ci/validation/check_bloc_coverage.dart coverage/presentation-bloc.lcov 50
dart run scripts/ci/validation/check_widgets_coverage.dart coverage/presentation-widgets.lcov 40

# Static analysis check
flutter analyze --no-pub --no-congratulate
```

## **Deep Dive Analysis**
```bash
# Module-specific testing
cd module/domain && flutter test --coverage
cd module/infrastructure && flutter test --coverage

# Presentation layer by category
flutter test --coverage --tags=bloc
flutter test --coverage test/presentation/**/widgets --exclude-tags=golden,accessibility,bloc
flutter test --coverage test/presentation/**/page --exclude-tags=golden,accessibility,bloc

# Check specific file coverage
flutter test --coverage test/path/to/specific_test.dart
```

## **Security & Quality Verification**
```bash
# Local OWASP-style dependency check (if available)
flutter pub deps
flutter pub audit

# SonarCloud-style analysis
flutter analyze --write=analyze_output.txt
dart run scripts/ci/validation/analyze_check.dart analyze_output.txt
```

---

# 💬 **Effective Review Communication**

## **Constructive Feedback Patterns**

### ✅ **Good Examples:**
```
🏗️ "Consider extracting this logic into a separate UseCase class to maintain 
    Single Responsibility Principle. See domain/usecases/ for examples."

🧪 "This edge case (empty list) isn't covered in tests. Consider adding:
    test('should handle empty breed list gracefully', () { ... })"

⚡ "This could be optimized by using StreamBuilder instead of polling.
    Performance docs: https://flutter.dev/docs/development/data-and-backend/state-mgmt/options#streambuilder"

✨ "Excellent separation of concerns in this repository implementation!"
```

### ❌ **Avoid:**
```
❌ "This is wrong" (not specific)
❌ "Bad code" (not constructive)  
❌ "Rewrite this" (no guidance)
❌ "I don't like this pattern" (personal preference without justification)
```

## **Non-Blocking vs Blocking Comments**

### **🚫 Block for:**
- Architecture violations (breaks Clean Architecture)
- Security vulnerabilities
- Breaking changes without migration path
- Test coverage below thresholds (when tools miss it)
- Business logic errors

### **💭 Comment (don't block) for:**
- Code style preferences (if tools didn't catch)
- Performance optimizations (unless critical)
- Future refactoring suggestions
- Alternative implementation ideas
- Educational feedback

---

# 🔄 **Review Process Workflow**

## **Step-by-Step Review Process**

### **1. Initial Assessment (2-3 minutes)**
1. **Check PR template completion** - Is checklist filled?
2. **Verify CI status** - All automated checks green?
3. **Review PR description** - Clear problem and solution?
4. **Identify PR type** - Feature/Bug/Deploy/Release?

### **2. Automated Tool Verification (3-5 minutes)**
1. **Coverage reports** - Thresholds met per module?
2. **SonarCloud quality gates** - New issues introduced?
3. **OWASP security scan** - Vulnerabilities found?
4. **Static analysis** - Critical issues present?

### **3. Code Review (10-20 minutes depending on size)**
1. **Architecture first** - Does it fit the clean architecture?
2. **Business logic** - Does it solve the right problem correctly?
3. **Testing strategy** - Are the right things tested well?
4. **Error handling** - Edge cases and failures covered?

### **4. Final Decision (1-2 minutes)**
1. **Apply decision criteria** based on PR type
2. **Leave constructive feedback**
3. **Approve, request changes, or comment**

## **Time Expectations by PR Type**

| PR Type | Expected Review Time | Focus Areas |
|---------|---------------------|-------------|
| **Feature** | 15-30 minutes | Architecture, business logic, testing |
| **Bug Fix** | 10-20 minutes | Root cause, fix quality, prevention |
| **Deploy** | 20-40 minutes | Safety, configuration, rollback plan |
| **Release** | 30-60 minutes | Comprehensive quality, coordination |

---

# 📊 **Quality Metrics to Monitor**

## **Red Flags in Automated Reports**
- **Coverage drops** below module thresholds
- **New SonarCloud issues** rated as blocker/critical
- **OWASP vulnerabilities** with high/critical severity
- **Analyze errors** (not warnings) in static analysis
- **Test failures** in any category

## **Architecture Red Flags**
- Domain layer importing from Infrastructure/Presentation
- UI components directly calling external APIs
- Business logic in presentation widgets
- Tight coupling between unrelated features
- Missing error handling for external dependencies

## **Performance Red Flags**
- Synchronous operations in main thread
- Memory leaks (missing dispose calls)
- Inefficient data structures for large datasets
- Unnecessary rebuilds in Flutter widgets
- Blocking operations without proper async handling

---

**Remember: Your expertise as a reviewer is most valuable for things that tools cannot assess - architecture decisions, business logic correctness, and user experience quality.**