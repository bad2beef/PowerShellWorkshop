<#
    Here is the gist: If you got this file from the workshop GitHub you’re
    probably fine. If not, this might not make a lot of sense. Check out the
    readme in the repository root. The short-short is that this is a guide to
    *your* exploration. Poke, play, prod, learn, break, hack, drink, fun!
                                                                         -CHRIS
                                                                      @bad2beef
                                 https://github.com/bad2beef/PowerShellWorkshop
#>
# 1.2.3
$Variable = 9
$Variable
$Variable = 9 + 2
$Variable
$Variable = value
$Variable = "value"
$Variable
$Variable = "Variable $Variable"
$Variable
$Variable = 'value'
$Variable
$Variable = 'Variable $Variable'
$Variable

# 1.2.4
$Variable.Length
$Variable.Type
$Variable.GetType
$Variable.GetType()
7.GetType()
(7).GetType()
'variable'.GetType()

# 1.2.5
ps
ps ax
Get-Process
Get-Process 'powershell'
Get-Process powershell
Get-Process('powershell')
Get-Process('powershell', 'explorer')
Get-Process powershell, explorer
Get-Process @( 'powershell', 'explorer' )
Get-Process -Name 'powershell'

# 1.2.6
1 + 1 * 10
( 1 + 1 ) * 10
notepad.exe
Get-Process -Name 'notepad'
Get-Process -Name Write-Output 'notepad'
Get-Process -Name ( Write-Output 'notepad' )
Get-Process -Name ( 'notepad' )

$Variable = 'notepad'
Get-Process -Name $Variable
Get-Process -Name ( $Variable = 'notepad' ; Write-Output $Variable )
Get-Process -Name $( $Variable = 'notepad' ; Write-Output $Variable )

notepad.exe
Get-Process -Name 'notepad'

$Variable = 'notepad' ; Write-Output $Variable
{ $Variable = 'notepad' ; Write-Output $Variable }
$ScriptBlock = { $Variable = 'notepad' ; Write-Output $Variable }
$ScriptBlock.Invoke()

Stop-Process -Name 'notepad'

# 1.2.7
3/2
[int]1.5
[int]3/2
[int]( 3/2 )
[int]one
[int]'one'
[int]''
[string]0

# 1.2.8
$Array = @( 1, 2, 3 )
$Array
$Array = 1, 2, 3
$Array
$Array.Count
$Array[1]
$Array.GetValue( 1 )
$Array[3] = 4
$Array.Add( 4 )
$Array += 4
$Array

$Hashtable = @{ 'One' = 1 ; 'Two' = 2 ; 'Three' = 3 }
$Hashtable
$Hashtable.Count
$Hashtable[1]
$Hashtable['One']
$Hashtable.One
$Hashtable.Item( 'One' )
$Hashtable.Keys
$Hashtable['Four'] = 4
$Hashtable
$Hashtable.Add( 'Five', 5 )
$Hashtable

# 1.2.9
1 = 2
1 == 2
1 -eq 2
1 -gt 2
1 -lt 2
1 -ge 2
1 -le 2
1 -not 2
-not 1 -le 2
-not 2 -le 2
-not ( 2 -le 2 )
2 -ne 2

"One" -eq "One"
"One" -like "One"
"One" -like "Two"
"One" -like "*o*"
"One" -notlike "Two"

@( 1, 2, 3 ) -contains 2
2 -in @( 1, 2, 3 )
@( 1, 2, 3 ) -ge 2

# 1.3
Write-Host -{TAB}
man Write-Host
Get-Help Write-Host
Get-Help about_Command_Syntax
Update-Help

# 2.1
Get-Process -Name 'powershell'
Get-Process -Name 'powershell' | Select-Object Name, Id
Get-Process -Name 'powershell' | Select-Object Name, Id, CPU(s)
Get-Process -Name 'powershell' | Select-Object Name, Id, 'CPU(s)'
Get-Process -Name 'powershell' | Select-Object Name, Id, CPU
Get-Help about_Types.ps1xml

# 2.2
Get-Process -Name 'powershell'
Get-Process | Where-Object { $_.Name -like 'powershell' }
Get-Process | Where-Object { $PSItem.Name -like 'powershell' }
Get-Process | Where-Object -FilterScript { $_.Name -like 'powershell' }
Get-Process | Where-Object -FilterScript { $_.Name -like 'powershell' ; $true }
Get-Process | Where-Object { ( $_.Name -like 'powershell' ) -and ( $_.CPU -gt 1 ) }
Get-Process | Where-Object Name -like 'Powershell'
Get-Process | Where-Object Name -like 'Powershell' -and 'CPU' -gt 1
Get-Process | Where-Object ( Name -like 'Powershell' ) -and ( 'CPU' -gt 1 )
Get-Command -Name 'Where-Object'
Get-Command -Name 'Where-Object' | Get-Member
Get-Command -Name 'Where-Object' | Select-Object Definition
Get-Command -Name 'Where-Object' | Select-Object -ExpandProperty Definition
Get-Process | Where-Object -Property 'Name' -like -Value 'powershell'
Get-Process | Where-Object { $_.StartTime -gt ( Get-Date ).AddHours( -2 ) }

# 2.3
Get-Process | Where-Object { $_.Name -like 'powershell' } > processes.txt
Get-Process | Where-Object { $_.Name -like 'powershell' } | Out-File -FilePath processes.txt
notepad.exe processes.txt

Get-Process | Out-File -FilePath processes.txt
Get-Content -Path processes.txt
Get-Content -Path processes.txt | Where-Object { 'ProcessName' -like '*powershell*' }
( Get-Content -Path processes.txt ).GetType()
( Get-Content -Path processes.txt )[10].GetType()
Get-Content -Path processes.txt | Where-Object { $_ -like '*powershell*' }
Get-Content -Path processes.txt  -Raw | Where-Object { $_ -like '*powershell*' }

Get-Process | Where-Object { $_.StartTime -gt ( Get-Date ).AddHours( -2 ) }
Get-Process | Where-Object { $_.StartTime -gt ( Get-Date ).AddHours( -2 ) } | Export-Csv -Path processes.csv
Import-Csv -Path processes.csv
Import-Csv -Path processes.csv | Where-Object { $_ -like 'powershell' }
( Import-Csv -Path processes.csv ).GetType()
( Import-Csv -Path processes.csv )[0].GetType()
( Import-Csv -Path processes.csv )[0] | Get-Member
Import-Csv -Path processes.csv | Where-Object { $_.Name -like 'powershell' }
Import-Csv -Path processes.csv | Where-Object { $_.Name -like 'powershell' } | Format-Table Name, Id, StartTime

Get-Process | Where-Object { $_.StartTime -gt ( Get-Date ).AddHours( -2 ) } | Export-Clixml -Path processes.xml
$Processes = Import-Clixml -Path processes.xml
$Processes
$Processes | Where-Object { $_.Name -like 'powershell' }
$PowerShellsFromFile = $Processes | Where-Object { $_.Name -like 'powershell' }
$PowerShellsFromFile

'ABC:123' | Out-File -FilePath map.txt -Append
'DEF:456' | Out-File -FilePath map.txt -Append
'GHI:789' | Out-File -FilePath map.txt -Append
Get-Content map.txt
$Map = @{}
Get-Content map.txt | ForEach-Object { $Parts = $_.Split( ':' ) ; $Map.Add( $Parts[0], $Parts[1] ) }
$Map
$Map[ 'GHI' ]

# 2.4
New-Item -Type File -Path test.txt
Get-Item -Path test.txt
Remove-Item -Path test.txt
New-Item -Type File -Path test.txt
Get-Item -Path test.txt | Remove-Item
Get-Item -Path test.txt

New-Item -Type File -Path test.txt
Get-ChildItem -Path .

$File = Get-Item -Path test.txt
$File
$File.Delete()
$File
Get-Item -Path test.txt
$File.Delete()

New-Item -Type File -Path test.txt
Get-ChildItem | Select-Object FullName
Get-ChildItem | Select-Object -ExpandProperty FullName

$Files = Get-ChildItem -Path 'C:\'
$Files = Get-ChildItem -Path 'C:\' -Recurse
^C
$Files = $Null

# 2.5
Get-ChildItem -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Run
Get-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Run

Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Run -Name 'notepad' -Value 'notepad.exe'
Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Run -Name 'notepad'

Get-ChildItem -Path HKCU:\Software\Microsoft\Windows\CurrentVersion

cd HKCU:
cd Software
dir

Get-PSDrive

# 3.1
Get-ExecutionPolicy
Get-ExecutionPolicy -List
Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy RemoteSigned

# 3.2
$Variable = 1
$AnotherVariable = 2
If ( $Variable -eq $AnotherVariable )
{
    Write-Host -ForegroundColor Green 'Equal!'
}
Else
{
    Write-Host -ForegroundColor Red 'Not equal!'
}

Switch ( $Variable )
{
    1 { Write-Host 'One' }
    2 { Write-Host 'Two' }
    3 { Write-Host 'Three' }
}

For ( $Variable = 0 ; $Variable -le 9 ; $Variable++ )
{
    Write-Host "Variable is $Variable."
}

$Processes = Get-Process -Name 'powershell'
ForEach ( $Process in $Processes )
{
    Write-Host "Process ID is $( $Process.Id )."
}

$Count = 0
While ( $Count -lt 3 )
{
    Write-Host "Count is $Count."
    $Count++
}

$Count = 0
Do
{
    Write-Host "Count is $Count."
    $Count++
}
While ( $Count -lt 3 )

$File = Get-Item -Path 'IDontExist.txt'
Try
{
    $File = Get-Item -Path 'IDontExist.txt'
    $File.Delete()
}
Catch
{
    Write-Warning 'Could not delete the file!'
}
Finally
{
    Write-Warning 'All done.'
}

# 3.3
Function AFunction
{
    Write-Host 'This is from the function.'
}
AFunction

Function CountTo ( $Number )
{
    For ( $Count = 1 ; $Count -le $Number ; $Count++ )
    {
        Write-Host "$Count Mississippi."
    }
}
CountTo(4)
CountTo 4
CountTo -Number 4

Function CountTo
{
    Param
    (
        $Number
    )

    For ( $Count = 1 ; $Count -le $Number ; $Count++ )
    {
        Write-Host "$Count Mississippi."
    }
}
CountTo 4

Function CountThese
{
    Param
    (
        $Object
    )

    Begin
    {
        $Count = 0
    }

    Process
    {
        $Count++
        Write-Host "I see object $Object. So far I have counted $Count objects..."
    }

    End
    {
        Write-Host "There are $Count objects total."
    }
}
CountThese -Object ( Get-Process )
( Get-Process ).GetType()
Get-Process | CountThese

Function Count-These
{
    [CmdletBinding()]
    Param
    (
        [Parameter(ValueFromPipeline=$True)]
        $Object
    )

    Begin
    {
        $Count = 0
    }

    Process
    {
        $Count++
        Write-Host "I see object $Object. So far I have counted $Count objects..."
    }

    End
    {
        Write-Host "There are $Count objects total."
    }
}
Get-Process | Count-These

# 3.4
Get-Process -Name 'powershell'
Get-Process @{ 'Name' = 'powershell' }
$GetProcessParameters = @{ 'Name' = 'powershell' }
Get-Process @GetProcessParameters

Get-Process @GetProcessParameters -FileVersionInfo
$GetProcessParameters.Add( 'FileVersionInfo' )
$GetProcessParameters.Add( 'FileVersionInfo', $true )
Get-Process @GetProcessParameters
Get-Process @GetProcessParameters -FileVersionInfo

# 3.5
$Object = New-Object
^C
$Object = New-Object -TypeName PSObject
$Object
$Object.Property1 = 1
Add-Member -InputObject $Object -MemberType NoteProperty -Name Property1 -Value 1
$Object
$Object | Add-Member -MemberType NoteProperty -Name Property2 -Value 2
$Object
$Object | Add-Member -MemberType ScriptProperty -Name Property3 -Value { $this.Property1 + $this.Property2 }
$Object
$Object.Property1 = 4
$Object

# 3.6
$Array = @( 1, 2, 3 )
$Array[2]
$Array[3] = 4
$Array[2] = 4
$Array
$Array.Add( 4 )

[System.Collections.ArrayList]$Array = @( 1, 2, 3 )
$Array
$Array[2]
$Array[3] = 4
$Array.Add( 4 )
$Array
$Array.Count
$Array.Add( 5 ) | Out-Null
$Array

# 4.1
Get-Module -ListAvailable
Get-Command -Module Microsoft.PowerShell.Utility

Import-Module -Name PSWorkflow
Remove-Module -Name PSWorkflow

Write-Host 'Hello!'
Function MyWriteHost ( $Object ) { Microsoft.PowerShell.Utility\Write-Host -ForegroundColor Green $Object }
Set-Alias Write-Host MyWriteHost
Write-Host 'Hello!'
Microsoft.PowerShell.Utility\Write-Host 'Hello!'

# 4.2
$env:PSModulePath
$env:PSModulePath.Split(';')[0]
$TestModuleDirectory = ( '{0}\Test' -f $env:PSModulePath.Split(';')[0] )
New-Item -ItemType Directory -Path $TestModuleDirectory

# BEGIN ~\Documents\WindowsPowerShell\Modules\Test\Test.psm1
Set-Content -Path ( '{0}\Test.psm1' -f $TestModuleDirectory ) -Value @'
Function AFunction
{
    Write-Host 'This is from the function.'
}
Export-ModuleMember -Function AFunction
'@
# END  ~\Documents\WindowsPowerShell\Modules\Test\Test.psm1

Import-Module Test
AFunction
Remove-Module Test

cd Documents\WindowsPowerShell\Modules\Test
New-ModuleManifest Test.psd1
# Test.psm1 < Export-ModuleMember -Function AFunction
# Test.psd1 > RootModule = 'Test.psm1'
# Test.psd1 > FunctionsToExport = @( 'AFunction' )

Import-Module Test
AFunction
Get-Command -Name AFunction
Remove-Module Test

# 5.1
powershell.exe -Command "Write-Host 'Hello world!'"
Set-Content -Path 'HelloWorld.ps1' -Value "Write-Host 'Hello world!'"
powershell.exe -ExecutionPolicy Bypass -NonInteractive -NoProfile -WindowStyle Normal -File 'HelloWorld.ps1'

$Script = "Write-Host 'Hello world!'"
$EncodedScript = [System.Convert]::ToBase64String( [System.Text.Encoding]::Unicode.GetBytes( $Script ) )
$EncodedScript
powershell.exe -EncodedCommand VwByAGkAdABlAC0ASABvAHMAdAAgACcASABlAGwAbABvACAAdwBvAHIAbABkACEAJwA=

# 5.2
Start-Job -ScriptBlock { Start-Sleep 10 }
Get-Job
Start-Job -ScriptBlock { Get-Process }
Receive-Job 3
Get-Job | Remove-Job

# 6.1
Invoke-WebRequest -Uri 'http://google.com'
$Response = Invoke-WebRequest -Uri 'http://google.com' -SessionVariable 'WebSession'
$WebSession
$Response.Forms[0].Fields
$Form = $Response.Forms[0]
$Form.Fields['q'] = 'powershell'
$Form.Submit()
$SearchResults = Invoke-WebRequest -Uri ( 'http://google.com' + $Form.Action ) -Method $Form.Method -WebSession $WebSession -Body $Form.Fields
$SearchResults.RawContent

$WebClient = New-Object -TypeName System.Net.WebClient
$WebClient.DownloadFile( 'https://www.google.com/favicon.ico', 'C:\Vagrant\google_icon.ico')

# 6.2
$Service = New-WebServiceProxy -Uri 'http://google.com'
$Service = New-WebServiceProxy -Uri 'http://www.webservicex.net/geoipservice.asmx?WSDL'
$Service | Get-Member
Get-Member -InputObject $Service -Name GetGeoIP | Format-List
Get-Member -InputObject $Service -Name GetGeoIPAsync | Format-List
$Service.GetGeoIP( '8.8.8.8' )

# 6.3
$IE = New-Object -TypeName 'InternetExplorer'
$IE = New-Object -ComObject 'InternetExplorer.Application'
$IE
$IE | Get-Member
$IE.GetType()
$IE.Visible = $true
$IE.Navigate( 'http://google.com' )
$IE
$IE.Document
$IE.Document | Get-Member
$IE.Document.cookie
$IE.Document.title
$IE.Document.title = 'Foobar!'
$IE.Document.childNodes[1].innerHTML
$IE.Quit()

# 7.1
$ComputerName = 'localhost'
$Credentials = Get-Credential
$Session = New-PSSession -Credential $Credentials -ComputerName $ComputerName
Enter-PSSession $Session
echo $env:COMPUTERNAME
exit
Remove-PSSession $Session

Invoke-Command -Credential $Credentials -ComputerName $ComputerName -ScriptBlock { Write-Host $env:COMPUTERNAME }

# 7.2
$ComputerName = 'localhost'
$Credentials = Get-Credential
$Session = New-CimSession -Credential $Credentials -ComputerName $ComputerName
Get-CimInstance -CimSession $Session -ClassName Win32_Service
Remove-CimSession $Session

# 8.1
$FilePath = ( '{0}\file.txt' -f ( Get-Location ).Path )
[System.IO.File]::WriteAllLines( $FilePath, ( Get-Process ) )
notepad.exe .\file.txt
[System.IO.File]::WriteAllLines( $FilePath, ( Get-Process | Out-String ) )
notepad.exe .\file.txt
[System.IO.File]::ReadAllText( $FilePath )

$FileStream = [System.IO.File]::Open( $FilePath, [System.IO.FileMode]::Open )
$FileStream
$FileStream.Seek( 123 )
$FileStream | Get-Member
$FileStream.Seek( 123 , [System.IO.SeekOrigin]::Begin )
$FileStream.ReadByte()
$FileStream.ReadByte()
[char]$FileStream.ReadByte()
[byte[]]$Buffer = 0..31 | ForEach-Object { Write-Output 0 }
$FileStream.Read( $Buffer, 0, $Buffer.Length )
$Buffer
[System.Text.Encoding]::ASCII.GetString( $Buffer )
$FileStream.Dispose()

Set-Content -Path '.\file.txt' -Value ( Get-Process | Out-String )
[IO.MemoryStream]$CompressedData = New-Object -TypeName System.IO.MemoryStream
[IO.Compression.GZipStream]$GZipStream = New-Object -TypeName System.IO.Compression.GZipStream -ArgumentList @( $CompressedData, [System.IO.Compression.CompressionMode]::Compress )
[IO.FileStream]$FileStream = New-Object -TypeName System.IO.FileStream -ArgumentList @( ( Get-Item '.\file.txt' ).FullName, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read )
$FileStream.CopyTo( $GZipStream )
$FileStream.Close()
$GZipStream.Close()
[System.Text.Encoding]::Default.GetString( $CompressedData.ToArray() )
