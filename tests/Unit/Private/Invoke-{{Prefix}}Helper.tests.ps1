[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSUseDeclaredVarsMoreThanAssignments',
    '',
    Justification = 'Pester BeforeAll/It scope'
)]
param()

BeforeDiscovery {
    # Build module if not running in psake build
    if ($null -eq $Env:BHBuildOutput) {
        $buildFilePath = Join-Path -Path $PSScriptRoot -ChildPath '..\..\..\build.psake.ps1'
        $invokePsakeParameters = @{
            TaskList  = 'Build'
            BuildFile = $buildFilePath
        }
        Invoke-psake @invokePsakeParameters
    }

    # PowerShellBuild outputs to Output/<ModuleName>/<Version>/
    $projectRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    $sourceManifest = Join-Path $projectRoot "$Env:BHProjectName/$Env:BHProjectName.psd1"
    $moduleVersion = (Import-PowerShellDataFile -Path $sourceManifest).ModuleVersion
    $Env:BHBuildOutput = Join-Path $projectRoot "Output/$Env:BHProjectName/$moduleVersion"
}

BeforeAll {
    # Import the module from the build output
    $moduleManifestPath = Join-Path -Path $Env:BHBuildOutput -ChildPath "$Env:BHProjectName.psd1"
    Get-Module $Env:BHProjectName | Remove-Module -Force -ErrorAction 'Ignore'
    Import-Module -Name $moduleManifestPath -Force -ErrorAction 'Stop'
}

InModuleScope $Env:BHProjectName {
    Describe 'Invoke-{{Prefix}}Helper' {

        Context 'Basic functionality' {

            It 'Returns the processed message' {
                $result = Invoke-{{Prefix}}Helper -Message 'Test message'
                $result | Should -Be 'Test message'
            }

            It 'Trims whitespace from message' {
                $result = Invoke-{{Prefix}}Helper -Message '  Test message  '
                $result | Should -Be 'Test message'
            }
        }

        Context 'Parameter validation' {

            It 'Throws on empty message' {
                { Invoke-{{Prefix}}Helper -Message '' } | Should -Throw
            }

            It 'Throws on null message' {
                { Invoke-{{Prefix}}Helper -Message $null } | Should -Throw
            }
        }

        Context 'Verbose output' {

            It 'Writes verbose messages when -Verbose is specified' {
                $verboseOutput = Invoke-{{Prefix}}Helper -Message 'Test' -Verbose 4>&1
                $verboseOutput | Should -Not -BeNullOrEmpty
            }
        }
    }
}
