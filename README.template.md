# {{ModuleName}}

{{Description}}

## Installation

### From PowerShell Gallery

```powershell
Install-Module -Name {{ModuleName}} -Scope CurrentUser
```

### From Source

```powershell
git clone {{ProjectUri}}.git
cd {{ModuleName}}
./build.ps1 -Task Build -Bootstrap
Import-Module ./Output/{{ModuleName}}/*/{{ModuleName}}.psd1
```

## Requirements

- PowerShell 5.1 or later (Desktop or Core)
- Windows, Linux, or macOS

## Quick Start

```powershell
# Import the module
Import-Module {{ModuleName}}

# Get help for available commands
Get-Command -Module {{ModuleName}}

# Example usage
Get-{{Prefix}}Example -Name 'World'
```

## Available Commands

| Command | Description |
|---------|-------------|
| `Get-{{Prefix}}Example` | Example public function |

## Development

### Prerequisites

- PowerShell 5.1+ or PowerShell 7+
- Git

### Building

```powershell
# Clone the repository
git clone {{ProjectUri}}.git
cd {{ModuleName}}

# Bootstrap dependencies and build
./build.ps1 -Task Build -Bootstrap

# Run tests
./build.ps1 -Task Test
```

### Project Structure

```
{{ModuleName}}/
├── {{ModuleName}}/           # Module source
│   ├── Public/               # Exported functions
│   └── Private/              # Internal helpers
├── tests/                    # Pester tests
│   ├── Unit/                 # Unit tests
│   ├── Meta.tests.ps1        # Code style tests
│   ├── Manifest.tests.ps1    # Manifest validation
│   └── Help.tests.ps1        # Help documentation tests
├── docs/                     # Documentation
├── .github/workflows/        # CI/CD pipelines
└── build.ps1                 # Build entry point
```

### Available Build Tasks

```powershell
./build.ps1 -Help
```

| Task | Description |
|------|-------------|
| `Build` | Build the module to Output/ |
| `Test` | Run all tests with code coverage |
| `Analyze` | Run PSScriptAnalyzer |
| `Pester` | Run Pester tests only |
| `Clean` | Remove build artifacts |
| `Publish` | Publish to PowerShell Gallery |

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests: `./build.ps1 -Task Test`
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.
