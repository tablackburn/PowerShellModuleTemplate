---
applyTo: '**/*'
description: 'Repository-specific instructions for {{ModuleName}}'
---

# {{ModuleName}} Repository Instructions

This file contains instructions specific to the {{ModuleName}} PowerShell module. These
instructions supplement the standard AIM modules and take precedence for repository-specific
conventions.

## Project Overview

{{Description}}

## Module Structure

```text
{{ModuleName}}/
├── {{ModuleName}}/
│   ├── Public/           # Exported cmdlets (user-facing functions)
│   ├── Private/          # Internal helper functions
│   ├── {{ModuleName}}.psd1   # Module manifest
│   └── {{ModuleName}}.psm1   # Module loader
├── tests/                # Pester tests
│   ├── Unit/Public/      # Tests for public functions
│   ├── Unit/Private/     # Tests for private functions
│   └── *.tests.ps1       # Meta, Manifest, Help tests
├── instructions/         # AI agent instructions (AIM)
├── build.ps1             # Build entry point
└── build.psake.ps1       # psake build tasks
```

## Naming Conventions

### Function Prefix

All public cmdlets use the `{{Prefix}}` prefix:

- `Get-{{Prefix}}Example`

### Private Function Naming

Private functions also use the `{{Prefix}}` prefix but are not exported:

- `Invoke-{{Prefix}}Helper`

## Testing Requirements

### Pester Tests

- All public functions must have corresponding tests in `tests/Unit/Public/`
- All private functions should have tests in `tests/Unit/Private/`
- Mock external dependencies - never make real HTTP requests in tests

### Running Tests

```powershell
# Run all tests
./build.ps1 -Task Test

# Run specific tests
Invoke-Pester -Path ./tests/Unit/Public/Get-{{Prefix}}Example.tests.ps1
```

## Build Process

The module uses psake for build automation:

```powershell
# Bootstrap and build
./build.ps1 -Task Build -Bootstrap

# Run specific tasks
./build.ps1 -Task Test
./build.ps1 -Task Analyze
```

## Dependencies

- PowerShell 5.1 or higher (PowerShell 7+ recommended)
- No external module dependencies for runtime
- Pester (for testing)
- psake (for build automation)

## Release Process

1. Update version in `{{ModuleName}}/{{ModuleName}}.psd1`
2. Update `CHANGELOG.md` with new version section
3. Commit changes with message: `chore: Bump version to X.Y.Z`
4. Push to main branch
5. CI will automatically publish to PowerShell Gallery when version changes
