<#
    HookWriteHost.psm1
    PowerShell Workshop Example
    Intercept Write-Host via an alias to add log output to a file and force all output on the console to be green on black.
    Demonstrates: Advanced Functions, Aliases, Basic Modules, Module Qualified Names, Spatting
#>

<#
    Define a function to replace Write-Host. Calling should match the original
    function to avoid breakage, so we create an Advanced Function. Its possible
    to take arbitrary parameters and reconstruct the call to Write-Host without
    explicitly listing “true” parameters, but we do define them anyway to
    demonstrate splatting and PSBoundParameters.
#>
Function Hook_Write-Host
{
    # Match original function parameters.
    [CmdletBinding()]
    param(
        [object]$Object,
        [switch]$NoNewline,
        [object]$Separator,
        [string]$ForegroundColor,
        [string]$BackgroundColor
    )

    begin
    {

    }

    process
    {
        # Take parameters passed to this function and store them somewhere mutable.
        $PassParameters = $PSBoundParameters
        
        # Remove values we will override if they exist. We don’t want to pass the same parameter twice.
        if ( $PassParameters.Keys -contains 'BackgroundColor' ) { $PassParameters.Remove( 'BackgroundColor' ) | Out-Null }
        if ( $PassParameters.Keys -contains 'ForegroundColor' ) { $PassParameters.Remove( 'ForegroundColor' ) | Out-Null }

        # Use Splatting to call the original Write-Host via its Module Qualified Name.
        Microsoft.PowerShell.Utility\Write-Host -BackgroundColor Black -ForegroundColor Green @PassParameters

        # And log the passed data out to a file.
        Out-File -Append -FilePath .\log.txt -InputObject $Object
    }

    end
    {

    }
}

# Define a function to set our hook via alias.
Function SetHook_Write-Host
{
    Set-Alias -Scope Global -Name 'Write-Host' -Value Hook_Write-Host
}

# Define a function to clear our hook via alias.
Function UnsetHook_Write-Host
{
    Remove-Item -Force 'Alias:\Write-Host'
}
