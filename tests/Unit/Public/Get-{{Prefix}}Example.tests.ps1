[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSUseDeclaredVarsMoreThanAssignments',
    '',
    Justification = 'Pester BeforeAll/It scope'
)]
param()

BeforeDiscovery {
    # Build module if not running in psake build
    if ($null -eq $Env:BHBuildOutput) {
        # Standalone run (e.g. Invoke-Pester on this file directly, or an agent
        # running one test): the module isn't built and the BuildHelpers env vars
        # aren't set. Defer to build.ps1 -- the canonical entry point -- to bootstrap
        # dependencies, set the BuildHelpers environment, and stage the module.
        # Invoke with & (not dot-sourcing): build.ps1 ends in an exit statement, and
        # the call operator contains it to the script boundary instead of ending the
        # whole Pester run.
        $buildScript = Join-Path -Path (Split-Path -Path (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent) -Parent) -ChildPath 'build.ps1'
        & $buildScript -Task 'Build' -Bootstrap
    }

    # PowerShellBuild outputs to Output/<ModuleName>/<Version>/
    $projectRoot = Split-Path -Path (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent) -Parent
    $sourceManifest = Join-Path -Path $projectRoot -ChildPath "$Env:BHProjectName/$Env:BHProjectName.psd1"
    $moduleVersion = (Import-PowerShellDataFile $sourceManifest).ModuleVersion
    $Env:BHBuildOutput = Join-Path -Path $projectRoot -ChildPath "Output/$Env:BHProjectName/$moduleVersion"
}

BeforeAll {
    # Import the module from the build output
    $moduleManifestPath = Join-Path -Path $Env:BHBuildOutput -ChildPath "$Env:BHProjectName.psd1"
    Get-Module $Env:BHProjectName | Remove-Module -Force -ErrorAction 'Ignore'
    Import-Module $moduleManifestPath -Force -ErrorAction 'Stop'
}

Describe 'Get-{{Prefix}}Example' {

    Context 'Basic functionality' {

        It 'Returns a greeting with default name' {
            $result = Get-{{Prefix}}Example
            $result | Should -Be 'Hello, World!'
        }

        It 'Returns a greeting with specified name' {
            $result = Get-{{Prefix}}Example 'PowerShell'
            $result | Should -Be 'Hello, PowerShell!'
        }

        It 'Accepts pipeline input' {
            $result = 'Test' | Get-{{Prefix}}Example
            $result | Should -Be 'Hello, Test!'
        }
    }

    Context 'Parameter validation' {

        It 'Throws on empty name' {
            { Get-{{Prefix}}Example '' } | Should -Throw
        }

        It 'Throws on null name' {
            { Get-{{Prefix}}Example $null } | Should -Throw
        }
    }

    Context 'Verbose output' {

        It 'Writes verbose messages when -Verbose is specified' {
            $verboseOutput = Get-{{Prefix}}Example 'Test' -Verbose 4>&1
            $verboseOutput | Should -Not -BeNullOrEmpty
        }
    }
}
