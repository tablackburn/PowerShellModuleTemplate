<#
.SYNOPSIS
    Initializes a new PowerShell module from this template.

.DESCRIPTION
    This script prompts for module configuration values and replaces all template
    placeholders throughout the repository. It also renames the module folder,
    generates a new GUID, and optionally initializes a Git repository.

.PARAMETER ModuleName
    The name of the new PowerShell module (e.g., 'MyAwesomeModule').

.PARAMETER Prefix
    The function prefix for cmdlets (e.g., 'Mam' for My Awesome Module).

.PARAMETER Author
    The author name for the module manifest.

.PARAMETER Description
    A brief description of what the module does.

.PARAMETER ProjectUri
    The GitHub repository URL for the project.

.PARAMETER NoGitInit
    Skip Git repository initialization.

.PARAMETER NoBootstrap
    Skip running the build bootstrap.

.EXAMPLE
    .\Initialize-Template.ps1

    Runs interactively, prompting for all values.

.EXAMPLE
    .\Initialize-Template.ps1 -ModuleName 'MyModule' -Prefix 'Mm' -Author 'John Doe' -Description 'My awesome module' -ProjectUri 'https://github.com/johndoe/MyModule'

    Initializes the template with the specified values.
#>
[CmdletBinding()]
param(
    [Parameter()]
    [string]
    $ModuleName,

    [Parameter()]
    [string]
    $Prefix,

    [Parameter()]
    [string]
    $Author,

    [Parameter()]
    [string]
    $Description,

    [Parameter()]
    [string]
    $ProjectUri,

    [Parameter()]
    [switch]
    $NoGitInit,

    [Parameter()]
    [switch]
    $NoBootstrap
)

$ErrorActionPreference = 'Stop'

# Function to prompt for value if not provided
function Get-ParameterValue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        $ParameterName,

        [Parameter(Mandatory)]
        [string]
        $Prompt,

        [Parameter()]
        [string]
        $CurrentValue,

        [Parameter()]
        [string]
        $DefaultValue
    )

    if (-not [string]::IsNullOrWhiteSpace($CurrentValue)) {
        return $CurrentValue
    }

    $promptText = $Prompt
    if ($DefaultValue) {
        $promptText += " [$DefaultValue]"
    }

    $result = Read-Host -Prompt $promptText
    if ([string]::IsNullOrWhiteSpace($result) -and $DefaultValue) {
        return $DefaultValue
    }

    if ([string]::IsNullOrWhiteSpace($result)) {
        throw "$ParameterName is required."
    }

    return $result
}

Write-Host ''
Write-Host '========================================' -ForegroundColor Cyan
Write-Host '  PowerShell Module Template Setup' -ForegroundColor Cyan
Write-Host '========================================' -ForegroundColor Cyan
Write-Host ''

# Check if template has already been initialized
$templateModuleFolder = Join-Path -Path $PSScriptRoot -ChildPath '{{ModuleName}}'
if (-not (Test-Path -Path $templateModuleFolder)) {
    Write-Warning 'This template appears to have already been initialized.'
    Write-Warning 'The {{ModuleName}} folder was not found.'
    $continue = Read-Host -Prompt 'Continue anyway? (y/N)'
    if ($continue -ne 'y') {
        Write-Host 'Initialization cancelled.' -ForegroundColor Yellow
        return
    }
}

# Gather parameters
$ModuleName = Get-ParameterValue -ParameterName 'ModuleName' -Prompt 'Module name (e.g., MyAwesomeModule)' -CurrentValue $ModuleName
$Prefix = Get-ParameterValue -ParameterName 'Prefix' -Prompt 'Function prefix (e.g., Mam for My Awesome Module)' -CurrentValue $Prefix
$Author = Get-ParameterValue -ParameterName 'Author' -Prompt 'Author name' -CurrentValue $Author
$Description = Get-ParameterValue -ParameterName 'Description' -Prompt 'Module description' -CurrentValue $Description
$ProjectUri = Get-ParameterValue -ParameterName 'ProjectUri' -Prompt 'GitHub repository URL' -CurrentValue $ProjectUri

# Generate new GUID
$newGuid = [guid]::NewGuid().ToString()
$currentDate = Get-Date -Format 'yyyy-MM-dd'
$currentYear = Get-Date -Format 'yyyy'

Write-Host ''
Write-Host 'Configuration Summary:' -ForegroundColor Green
Write-Host "  Module Name:  $ModuleName"
Write-Host "  Prefix:       $Prefix"
Write-Host "  Author:       $Author"
Write-Host "  Description:  $Description"
Write-Host "  Project URI:  $ProjectUri"
Write-Host "  GUID:         $newGuid"
Write-Host ''

$confirm = Read-Host -Prompt 'Proceed with initialization? (Y/n)'
if ($confirm -eq 'n') {
    Write-Host 'Initialization cancelled.' -ForegroundColor Yellow
    return
}

Write-Host ''
Write-Host 'Initializing template...' -ForegroundColor Cyan

# Define placeholder replacements
$replacements = @{
    '{{ModuleName}}'  = $ModuleName
    '{{Prefix}}'      = $Prefix
    '{{Author}}'      = $Author
    '{{Description}}' = $Description
    '{{ProjectUri}}'  = $ProjectUri
    '{{GUID}}'        = $newGuid
    '{{Date}}'        = $currentDate
    '{{Year}}'        = $currentYear
}

# Get all files that might contain placeholders
$filesToProcess = Get-ChildItem -Path $PSScriptRoot -Recurse -File | Where-Object {
    $_.FullName -notmatch '[\\/]\.git[\\/]' -and
    $_.FullName -notmatch '[\\/]Output[\\/]' -and
    $_.FullName -notmatch '[\\/]out[\\/]' -and
    $_.Name -ne 'Initialize-Template.ps1' -and
    $_.Extension -in @('.ps1', '.psm1', '.psd1', '.md', '.json', '.yml', '.yaml', '.xml', '.txt', '')
}

# Process each file
$processedCount = 0
foreach ($file in $filesToProcess) {
    $content = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
    if ($null -eq $content) {
        continue
    }

    $originalContent = $content
    foreach ($placeholder in $replacements.Keys) {
        $content = $content -replace [regex]::Escape($placeholder), $replacements[$placeholder]
    }

    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Verbose "Updated: $($file.FullName)"
        $processedCount++
    }
}

Write-Host "  Updated $processedCount files with placeholder values" -ForegroundColor Green

# Rename module folder if it exists
if (Test-Path -Path $templateModuleFolder) {
    $newModuleFolder = Join-Path -Path $PSScriptRoot -ChildPath $ModuleName
    Rename-Item -Path $templateModuleFolder -NewName $ModuleName
    Write-Host "  Renamed module folder to: $ModuleName" -ForegroundColor Green

    # Rename files inside module folder
    $moduleFolder = $newModuleFolder
    $filesToRename = Get-ChildItem -Path $moduleFolder -Recurse -File | Where-Object {
        $_.Name -match '\{\{ModuleName\}\}'
    }

    foreach ($file in $filesToRename) {
        $newName = $file.Name -replace '\{\{ModuleName\}\}', $ModuleName
        $newPath = Join-Path -Path $file.DirectoryName -ChildPath $newName
        Rename-Item -Path $file.FullName -NewName $newName
        Write-Verbose "Renamed: $($file.Name) -> $newName"
    }

    # Rename the psd1 and psm1 files
    $psd1File = Join-Path -Path $moduleFolder -ChildPath '{{ModuleName}}.psd1'
    $psm1File = Join-Path -Path $moduleFolder -ChildPath '{{ModuleName}}.psm1'

    if (Test-Path -Path $psd1File) {
        Rename-Item -Path $psd1File -NewName "$ModuleName.psd1"
        Write-Host "  Renamed manifest: $ModuleName.psd1" -ForegroundColor Green
    }

    if (Test-Path -Path $psm1File) {
        Rename-Item -Path $psm1File -NewName "$ModuleName.psm1"
        Write-Host "  Renamed module: $ModuleName.psm1" -ForegroundColor Green
    }

    # Rename example function files
    $publicFolder = Join-Path -Path $moduleFolder -ChildPath 'Public'
    $privateFolder = Join-Path -Path $moduleFolder -ChildPath 'Private'
    $testPublicFolder = Join-Path -Path $PSScriptRoot -ChildPath 'tests\Unit\Public'
    $testPrivateFolder = Join-Path -Path $PSScriptRoot -ChildPath 'tests\Unit\Private'

    $foldersToCheck = @($publicFolder, $privateFolder, $testPublicFolder, $testPrivateFolder)

    foreach ($folder in $foldersToCheck) {
        if (Test-Path -Path $folder) {
            $files = Get-ChildItem -Path $folder -File | Where-Object {
                $_.Name -match '\{\{Prefix\}\}'
            }
            foreach ($file in $files) {
                $newName = $file.Name -replace '\{\{Prefix\}\}', $Prefix
                Rename-Item -Path $file.FullName -NewName $newName
                Write-Verbose "Renamed: $($file.Name) -> $newName"
            }
        }
    }

    Write-Host '  Renamed example function files' -ForegroundColor Green
}

# Initialize Git repository if requested
if (-not $NoGitInit) {
    $gitFolder = Join-Path -Path $PSScriptRoot -ChildPath '.git'
    if (-not (Test-Path -Path $gitFolder)) {
        Write-Host '  Initializing Git repository...' -ForegroundColor Cyan
        Push-Location -Path $PSScriptRoot
        try {
            git init
            git add -A
            git commit -m "chore: Initialize $ModuleName from PowerShell module template"
            Write-Host '  Git repository initialized with initial commit' -ForegroundColor Green
        }
        finally {
            Pop-Location
        }
    }
    else {
        Write-Host '  Git repository already exists, skipping initialization' -ForegroundColor Yellow
    }
}

# Run bootstrap if requested
if (-not $NoBootstrap) {
    Write-Host ''
    Write-Host 'Running build bootstrap...' -ForegroundColor Cyan
    $buildScript = Join-Path -Path $PSScriptRoot -ChildPath 'build.ps1'
    if (Test-Path -Path $buildScript) {
        & $buildScript -Bootstrap
    }
    else {
        Write-Warning 'build.ps1 not found, skipping bootstrap'
    }
}

Write-Host ''
Write-Host '========================================' -ForegroundColor Green
Write-Host '  Template initialization complete!' -ForegroundColor Green
Write-Host '========================================' -ForegroundColor Green
Write-Host ''
Write-Host 'Next steps:' -ForegroundColor Cyan
Write-Host "  1. Review the generated files in the $ModuleName folder"
Write-Host '  2. Update the README.md with your project details'
Write-Host '  3. Add your functions to the Public/ and Private/ folders'
Write-Host '  4. Run ./build.ps1 -Task Test to verify everything works'
Write-Host '  5. Push to your GitHub repository'
Write-Host ''
Write-Host 'You can safely delete this Initialize-Template.ps1 file.' -ForegroundColor Yellow
Write-Host ''
