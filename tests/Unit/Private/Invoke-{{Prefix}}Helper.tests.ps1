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

InModuleScope -ModuleName $Env:BHProjectName -ScriptBlock {
    Describe 'Invoke-{{Prefix}}Helper' {

        Context 'Basic functionality' {

            It 'Returns the processed message' {
                $result = Invoke-{{Prefix}}Helper 'Test message'
                $result | Should -Be 'Test message'
            }

            It 'Trims whitespace from message' {
                $result = Invoke-{{Prefix}}Helper '  Test message  '
                $result | Should -Be 'Test message'
            }
        }

        Context 'Parameter validation' {

            It 'Throws on empty message' {
                { Invoke-{{Prefix}}Helper '' } | Should -Throw
            }

            It 'Throws on null message' {
                { Invoke-{{Prefix}}Helper $null } | Should -Throw
            }
        }

        Context 'Verbose output' {

            It 'Writes verbose messages when -Verbose is specified' {
                $verboseOutput = Invoke-{{Prefix}}Helper 'Test' -Verbose 4>&1
                $verboseOutput | Should -Not -BeNullOrEmpty
            }
        }
    }
}
