# https://learn.microsoft.com/en-us/powershell/utility-modules/psscriptanalyzer/using-scriptanalyzer
@{
    IncludeDefaultRules = $true

    IncludeRules        = @(
        # Default rules
        'PS*'
    )

    # If IncludeRules and ExcludeRules are empty, all rules will be applied
    ExcludeRules        = @()

    Rules               = @{
        #  PSUseCompatibleSyntax  = @{
        #    # This turns the rule on (setting it to false will turn it off)
        #    Enable         = $true

        #    # List the targeted versions of PowerShell here
        #    TargetVersions = @(
        #      '5.1',
        #      '7.2'
        #    )
        #  }
        #  PSUseCompatibleCmdlets = @{
        #    compatibility = @('core-7.2.0-windows')
        #  }
    }
}
