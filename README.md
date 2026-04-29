# PowerShell Module Template

A GitHub repository template for building, testing, and publishing PowerShell modules. Click **Use this template** at the top of the repo, run a one-shot init script, and you have a working module project with CI, tests, and documentation scaffolding ready to go.

## What's included

### Build & test

- **psake + PowerShellBuild** task pipeline (`build.ps1`, `build.psake.ps1`)
- **Pester 5.x** test layout with `tests/Unit/{Public,Private}` scaffolding
- **PSScriptAnalyzer** lint configuration
- **Code coverage** via JaCoCo + Codecov (`codecov.yml`)
- **Manifest validation tests** with SemVer-aware version-constraint checks (`tests/Manifest.tests.ps1`, `tests/ManifestHelpers.psm1`)
- **Help documentation tests** that verify every public function has comment-based help with synopsis, description, and examples (`tests/Help.tests.ps1`)
- **Meta tests** that catch UTF-16 files and tab indentation (`tests/Meta.tests.ps1`)
- **Integration test loader** — `tests/local.settings.example.ps1` documents how to wire local secrets without committing them

### CI/CD (GitHub Actions)

- `CI.yaml` — lint + test on push and PR
- `PublishModuleToPowerShellGallery.yaml` — publish on release
- `auto-merge-bots.yml` — auto-merge dependabot/pre-commit PRs
- `ggshield.yaml` — secret scanning
- Dependabot config and FUNDING file

### Developer experience

- **`.devcontainer/`** with Docker Compose + host setup script
- **`.pre-commit-config.yaml`** with ggshield secret scanning
- **`instructions/`** — 12 markdown guides for AI agents (PowerShell style, testing, releases, git workflow, etc.)
- **`AGENTS.md`** — top-level AI agent guidance
- Markdown linting via `.markdownlint-cli2.jsonc`

### Module scaffolding

- Full `.psd1` manifest with PSEdition tags, license/project URIs, and PSData metadata
- `.psm1` with public/private dot-source pattern
- Example public function (`Get-{{Prefix}}Example`) and private helper (`Invoke-{{Prefix}}Helper`)
- `docs/en-US/about_{{ModuleName}}.help.md` stub for `Get-Help about_<Module>`

## Quick start

1. Click **Use this template → Create a new repository** at the top of this repo.
2. Clone your new repository locally.
3. Run the initialization script:

   ```powershell
   ./Initialize-Template.ps1
   ```

   You'll be prompted for module name, function prefix, author, description, and project URL. Pass them as parameters for non-interactive use:

   ```powershell
   ./Initialize-Template.ps1 `
       -ModuleName 'MyAwesomeModule' `
       -Prefix 'Mam' `
       -Author 'Jane Doe' `
       -Description 'Does awesome things' `
       -ProjectUri 'https://github.com/janedoe/MyAwesomeModule'
   ```

4. The script substitutes placeholders, renames files, optionally runs `git init`, and bootstraps build dependencies. Delete `Initialize-Template.ps1` when done.

## Placeholders

`Initialize-Template.ps1` replaces these tokens across all `.ps1`, `.psm1`, `.psd1`, `.md`, `.json`, `.yml`, `.yaml`, `.xml`, and `.txt` files:

| Placeholder | Replaced with | Example |
|---|---|---|
| `{{ModuleName}}` | Module name | `MyAwesomeModule` |
| `{{Prefix}}` | Function noun prefix | `Mam` |
| `{{Author}}` | Author name | `Jane Doe` |
| `{{Description}}` | Module description | `Does awesome things` |
| `{{ProjectUri}}` | Repository URL | `https://github.com/...` |
| `{{GUID}}` | Generated GUID | (new GUID per run) |
| `{{Date}}` | ISO date at init | `2026-04-29` |
| `{{Year}}` | Year at init | `2026` |

The script also renames the `{{ModuleName}}` folder, files containing `{{ModuleName}}` or `{{Prefix}}` in their names (in `Public/`, `Private/`, `tests/Unit/`, `docs/en-US/`), and replaces `README.md` with the post-init module README sourced from `README.template.md`.

## Project structure (post-init)

```
<ModuleName>/
├── <ModuleName>/                 # Module source
│   ├── Public/                   # Exported functions
│   └── Private/                  # Internal helpers
├── tests/
│   ├── Unit/{Public,Private}/    # Per-function tests
│   ├── Help.tests.ps1            # Comment-based-help validation
│   ├── Manifest.tests.ps1        # Manifest + dependency-version validation
│   ├── Meta.tests.ps1            # Encoding + indentation checks
│   └── ManifestHelpers.psm1      # SemVer comparison helpers
├── docs/en-US/                   # platyPS help (generated)
├── instructions/                 # AI agent guidance (12 files)
├── .github/workflows/            # CI, publish, auto-merge, secret scan
├── .devcontainer/                # VS Code dev container
├── build.ps1                     # Build entry point
├── build.psake.ps1               # psake task definitions
├── build.depend.psd1             # Build/test module dependencies
└── requirements.psd1             # Runtime module dependencies
```

## Working on the template itself

If you want to contribute to the template (this repo) rather than use it:

```powershell
./build.ps1 -Task Test -Bootstrap
```

The test suite runs against the `{{ModuleName}}` placeholder module to verify the scaffolding is sound. See [AGENTS.md](AGENTS.md) and [`instructions/`](instructions/) for contribution conventions.

## Requirements

- PowerShell 5.1+ or PowerShell 7+
- Git
- (Optional) Docker for the devcontainer

## License

[MIT](LICENSE)
