# Gitleaks Configuration

This directory contains the specific configuration for Gitleaks, the secret detection tool.

## Current Configuration

Gitleaks uses its internal default configuration, which detects:
- API keys
- Hardcoded passwords
- Authentication tokens
- Private keys in content
- Other common secrets

## Separation of Responsibilities

- **Gitleaks**: Detects secrets in file **content** (tokens, passwords, etc.)
- **Semgrep**: Detects sensitive files by **extension** (`.p12`, `.jks`, etc.)

Both tools are complementary and cover different security aspects.

## Pipeline

Execution is configured in `.github/workflows/gitleaks.yml`

## Notes

Gitleaks focuses on hardcoded secrets in code, while Semgrep detects files that should never be in the repository.