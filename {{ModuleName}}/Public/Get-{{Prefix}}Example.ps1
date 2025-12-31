function Get-{{Prefix}}Example {
    <#
    .SYNOPSIS
        Example public function for {{ModuleName}}.

    .DESCRIPTION
        This is an example public function that demonstrates the standard function template
        used in this module. Replace this with your actual implementation.

    .PARAMETER Name
        The name to use in the greeting. If not specified, defaults to 'World'.

    .EXAMPLE
        Get-{{Prefix}}Example

        Returns a greeting with the default name.

    .EXAMPLE
        Get-{{Prefix}}Example -Name 'PowerShell'

        Returns a greeting with the specified name.

    .OUTPUTS
        System.String
        Returns a greeting message.

    .NOTES
        This is an example function. Replace with your actual implementation.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name = 'World'
    )

    begin {
        Write-Verbose "Starting Get-{{Prefix}}Example"
    }

    process {
        try {
            $greeting = Invoke-{{Prefix}}Helper -Message "Hello, $Name!"
            Write-Output $greeting
        }
        catch {
            throw "Failed to generate greeting: $($_.Exception.Message)"
        }
    }

    end {
        Write-Verbose "Completed Get-{{Prefix}}Example"
    }
}
