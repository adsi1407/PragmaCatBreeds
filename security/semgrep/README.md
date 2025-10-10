# Semgrep Security Rules

This directory contains Semgrep rules for static security analysis of the PragmaCatBreeds project.

## Included Rules

### `cert-files.yml`
Detects files with extensions commonly used for certificates and keystores:
- `.p12`, `.pfx`, `.pem`, `.key`, `.crt`, `.cer`, `.p8`, `.jks`, `.keystore`

### `possible-id-colombia.yml`
Detects possible Colombian ID numbers (7-10 digits) in source files.

## Usage

### CI/CD Pipeline
Rules are automatically executed via `.github/workflows/semgrep.yml` using the official Semgrep action.

### Local Testing
```bash
# With Docker (recommended)
docker run --rm -v "${PWD}:/src" returntocorp/semgrep --config=security/semgrep/ /src

# Or install Semgrep locally
pip install semgrep
semgrep --config=security/semgrep/
```

## Tuning

- **False Positives**: Use `pattern-not` or `path` filters for specific cases
- **Severity**: Start with `WARNING` for PII rules and iterate
- **Allowlist**: Consider for persistent and justified exceptions
