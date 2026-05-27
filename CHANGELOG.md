# Changelog

All notable changes to this template will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project uses [Calendar Versioning](https://calver.org/) (`YYYY.MM.DD`).

For the changelog of a *module initialized from this template*, see the module's
own `CHANGELOG.md` (generated from `CHANGELOG.template.md` during init).

## [Unreleased]

### Added

- "Repository secrets" section in `README.md` documenting the GitHub Actions secrets the bundled workflows expect (`PSGALLERY_API_KEY`, `CODECOV_TOKEN`, `GITGUARDIAN_API_KEY`) — required vs. optional, source, and failure mode when missing.
- `Initialize-Template.ps1` now mentions configuring GitHub repository secrets in its post-init "Next steps" output, between the build-test step and the first push.

### Changed

- Renamed required PowerShell Gallery publish secret `PS_GALLERY_KEY` → `PSGALLERY_API_KEY` so the secret name matches the env var name PowerShellBuild reads (eliminating the previous mapping caveat). New modules created from the template after this change pick up the new name automatically. **Migration for existing modules:** create a new `PSGALLERY_API_KEY` repo secret with the same value, update `.github/workflows/PublishModuleToPowerShellGallery.yaml` to reference `secrets.PSGALLERY_API_KEY`, then delete the old `PS_GALLERY_KEY` secret.
- Test scaffolding (`tests/Help.tests.ps1`, `tests/Manifest.tests.ps1`, `tests/Meta.tests.ps1`, `tests/MetaFixers.psm1`, and the `tests/Unit/` templates) no longer names parameters on single-argument calls (e.g. `Test-Path $path`, `Get-Module $name`, `Get-Help $command`), matching the scoped named-parameter rule — name parameters only when a call passes two or more arguments. A trailing switch counts as an argument, so `Split-Path -Path $x -Parent`, `Get-Content -Path $x -Raw`, and `Get-ChildItem -Path $x -Recurse` keep their names, as do genuinely multi-value calls (`Join-Path`, `Get-Command -Name … -CommandType …`) and `Test-Path -LiteralPath`.

## [2026.04.29] - 2026-04-29

### Added

- SemVer-aware dependency version checks: new `tests/ManifestHelpers.psm1` exporting `Test-VersionConstraint`. `tests/Manifest.tests.ps1` now differentiates `RequiredVersion` / `ModuleVersion` / `MaximumVersion`, accepts both string and hashtable shapes in `requirements.psd1`, and detects duplicate `RequiredModules` entries.
- README split: template-facing `README.md` (what GitHub visitors see) and module-facing `README.template.md` (substituted into `README.md` during init).
- `docs/en-US/about_{{ModuleName}}.help.md` stub for `Get-Help about_<Module>`. `Initialize-Template.ps1` now also renames `{{ModuleName}}` files in `docs/en-US/`.
- `.gitattributes` marking `docs/en-US/*` as `linguist-generated`.
- `.markdownlint-cli2.jsonc` config (relax MD013 in tables/code, allow MD024 siblings, ignore generated docs and `instructions/`).

### Changed

- `PSScriptAnalyzerSettings.psd1`: replaced one-line `@{ IncludeRules = @('*') }` with the structured form (Include/Exclude/Rules + commented compat scaffold).
- Bumped `PSScriptAnalyzer` 1.24.0 → 1.25.0.

### Fixed

- `tests/Help.tests.ps1`: replaced undefined `$parameterNames` with `$commandParameterNames` in the help-vs-code parameter check (was silently asserting against `$null`).
- `{{ModuleName}}/{{ModuleName}}.psm1`: dot-source catch block now preserves the original `ErrorRecord` via bare `throw`. Previously the catch threw a new string (`"Unable to dot source ..."`), which wrapped the original exception in a fresh `ErrorRecord` and lost the underlying stack trace.

[Unreleased]: https://github.com/tablackburn/PowerShellModuleTemplate/compare/v2026.04.29...HEAD
[2026.04.29]: https://github.com/tablackburn/PowerShellModuleTemplate/releases/tag/v2026.04.29
