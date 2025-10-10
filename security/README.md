# Security Configuration

This directory contains security configurations organized by tool.

## 📁 Structure

```
security/
├── gitleaks/              # Gitleaks-specific configuration
│   └── README.md
├── semgrep/               # Semgrep rules
│   ├── cert-files.yml
│   ├── possible-id-colombia.yml
│   └── README.md
└── README.md              # This file
```

## 🛠️ Security Tools

### Gitleaks
- **Purpose**: Secret detection in content (API keys, tokens, passwords)
- **Configuration**: Uses internal default configuration
- **Pipeline**: `.github/workflows/gitleaks.yml`

### Semgrep
- **Purpose**: Static code analysis and sensitive file detection
- **Configuration**: Custom rules in `security/semgrep/`
- **Pipeline**: `.github/workflows/semgrep.yml`

## 🎯 Structure Benefits

### ✅ Advantages
- **Organization**: Each tool has its specific space
- **Maintenance**: Easy location and updates
- **Scalability**: Simple to add new tools

### 🔧 Workflow
To add new security rules:
1. Determine the appropriate tool (Gitleaks vs Semgrep)
2. Create/update rules in the corresponding directory
3. Document changes in specific READMEs

## 🚨 Security Policy

Any sensitive file detected:
- 🚫 **MUST NOT be committed** ever
- 🔒 **MUST be added to .gitignore**
- 🛡️ **MUST be stored in secure vault**
- 🔄 **MUST be rotated if exposed**

For more information, see: [GitHub Security Best Practices](https://docs.github.com/en/code-security)