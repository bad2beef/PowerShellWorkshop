<#
    GetRunningImageHashes.ps1
    PowerShell Workshop Example
    Report file hashes for each unique executable image currently running.
#>
<#
    Define a separate function for computing file hashes. We separate it out to
    keep our code more readable, and to aide code reuse. This process is better
    served by using the Get-FileHash cmdlet, however we create a custom version
    ourselves for instructional purposes.
#>
Function GetFileHash ( $FilePath )
{
    $FileStream = [System.IO.File]::Open( $FilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read )
    [Byte[]]$FileBytes = [System.Byte[]]::new( $FileStream.Length )
    $FileStream.Read( $FileBytes, 0, $FileStream.Length ) | Out-Null
    $FileStream.Dispose()

    $SHA256 = [System.Security.Cryptography.SHA256]::Create()
    $FileHashBytes = $SHA256.ComputeHash( $FileBytes, 0, $FileBytes.Length )

    [System.Text.StringBuilder]$FileHashHex = [System.Text.StringBuilder]::new( $FileHashBytes.Length * 2 )
    $FileHashBytes | ForEach-Object { $FileHashHex.AppendFormat( '{0:x2}', $_ ) | Out-Null }

    $FileHashHex.ToString();
}


<#
    Define a target variable for our report data so we can consolidate it. In
    practice, we shouldn’t do this much. Instead, its generally better to
    stream objects out of the pipeline as we go. We’re not doing that here for
    instructional purposes.
#>
[System.Collections.ArrayList]$ProcessInfo = @()

# Collect a list of unique running executable images on the system.
$Processes = Get-Process | Select-Object -Unique Path -ExpandProperty Path

# Iterate over each one, adding data to our report as we go.
ForEach ( $Process in $Processes )
{
    # Create a custom object and populate it with members.
    $ProcessEntry = New-Object -TypeName PSObject
    $ProcessEntry | Add-Member -MemberType NoteProperty -Name 'Path' -Value $Process
    $ProcessEntry | Add-Member -MemberType NoteProperty -Name 'FileHash' -Value ( GetFileHash( $Process ) )
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

    # Add the completed report object to our report dataset.
    $ProcessInfo.Add( $ProcessEntry ) | Out-Null
}

<#
    Display the report data back out on the console. Again, normally we
    wouldn’t do this. Streaming data out and handling formatting and
    display separately is a better pattern.
#>
$ProcessInfo | Select-Object FileHash, Status, Path | Format-Table -AutoSize
