Semgrep rules for PragmaCatBreeds
===================================

This folder contains example Semgrep rules used by the project's GitHub Actions workflow.

Included rules:
- `possible-id-colombia.yml` — regex-based rule to flag possible Colombian ID numbers (7-10 digits) in source files.
- `cert-files.yml` — detect filenames/extensions commonly used for certificates/keystores.

Usage
-----
- The repository includes a workflow `.github/workflows/semgrep.yml` which runs Semgrep on pull requests and pushes to `main` using the official Semgrep GitHub Action. No local installation is required.
- To test locally without installing Semgrep, use Docker (if available) or run the Action in a throwaway branch.

Tuning
------
- Start with `severity: WARNING` for PII rules and iterate. Add `path` filters or `pattern-not` clauses to reduce false positives.
- For persistent false positives, consider adding an allowlist entry or adjust the rule to target a narrower AST pattern.
