<#
    GetRunningImageHashesPipeline.ps1
    PowerShell Workshop Example
    Cleaner version of the GetRunningImageHashes.
    Demonstrates: Custom Objects / PSObject, Invoke-WebRequest, Regular Expression -match
    Invoke .\GetRunningImageHashesPipeline.ps1 | Select-Object FileHash, Status, Path | Format-Table -AutoSize
#>

# Collect a list of unique running executable images on the system.
$Processes = Get-Process | Select-Object -Unique Path -ExpandProperty Path

# Iterate over each one, pushing out data as we go.
ForEach ( $Process in $Processes )
{
    # Create a custom object and populate it with members.
    $ProcessEntry = New-Object -TypeName PSObject
    $ProcessEntry | Add-Member -MemberType NoteProperty -Name 'Path' -Value $Process
    $ProcessEntry | Add-Member -MemberType NoteProperty -Name 'FileHash' -Value ( Get-FileHash -Algorithm SHA256 -Path $Process ).Hash
    $ProcessEntry | Add-Member -MemberType NoteProperty -Name 'Status' -Value $Null

    # We want to be nice for once, so we’ll only add data for the Status column if the current image is notepad.exe .
    If ( $Process -like '*\notepad.exe' )
    {
        # Make a request to a web page for a traditional screen-scrape. API access is preferred.
        $FileStatus = Invoke-WebRequest `
            -UseBasicParsing `
            -Uri ( 'https://www.reverse.it/sample/{0}' -f $ProcessEntry.FileHash ) `
            -UserAgent 'Google Chrome Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36'
        
        # Resulting data can be large and cause regexes to be extremely slow, so we’ll chop out a target area of the returned HTML first.
        $SearchOffset = $FileStatus.Content.IndexOf( 'basic-malware-detection-info' )
        $SearchSubstring = $FileStatus.Content.Substring( $SearchOffset, 300)

        # Then we will regex only the small stub of data for better performance.
        $SearchSubstring -match '(?smi)basic-malware-detection-info.*?label.*?\>([\w\s]+)\<.*' | Out-Null
        $ProcessEntry.Status = $matches[1].Trim()
    }

    # Push report entry out on the pipeline.
    Write-Output $ProcessEntry
}
