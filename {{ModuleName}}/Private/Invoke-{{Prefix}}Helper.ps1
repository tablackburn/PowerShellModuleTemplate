function Invoke-{{Prefix}}Helper {
    <#
    .SYNOPSIS
        Example private helper function.

    .DESCRIPTION
        This is an example private helper function that is used internally by public functions.
        Private functions are not exported from the module and cannot be called directly by users.

    .PARAMETER Message
        The message to process.

    .EXAMPLE
        Invoke-{{Prefix}}Helper -Message 'Hello, World!'

        Returns the processed message.

    .OUTPUTS
        System.String
        Returns the processed message.

    .NOTES
        This is an internal function. Replace with your actual implementation.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Message
    )

    try {
        # Example processing - replace with actual logic
        $processedMessage = $Message.Trim()

        Write-Verbose "Processed message: $processedMessage"

        return $processedMessage
    }
    catch {
        throw "Failed to process message: $($_.Exception.Message)"
    }
}
