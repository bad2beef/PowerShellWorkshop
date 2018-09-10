#region Filesystem Watcher

$fileWatcher = New-Object System.IO.FileSystemWatcher

if ($env:os -eq 'Windows_NT'){
$fileWatcher.Path = "C:\temp\"
if (!(Test-Path C:\temp)){
    mkdir C:\temp
}
}

elseif (& sw_vers){
$fileWatcher.Path = "/Users"
}

elseif ($env:os -eq 'linux'){
$fileWatcher.Path = "/Users"
}


$fileWatcher.IncludeSubdirectories = $true
$fileWatcher.EnableRaisingEvents = $true 

Register-ObjectEvent -InputObject $fileWatcher -EventName Created -SourceIdentifier File.Created -Action {
    $Global:t = $event
    Write-Host ("{2} File Created: {0} on {1}" -f $event.SourceEventArgs.Name,
    (Split-Path $event.SourceEventArgs.FullPath),(get-date))
} | Out-Null

Register-ObjectEvent -InputObject $fileWatcher -EventName Deleted -SourceIdentifier File.Deleted -Action {
    $Global:t = $event
    Write-Host ("{2} File Deleted: {0} on {1}" -f $event.SourceEventArgs.Name,
    (Split-Path $event.SourceEventArgs.FullPath),(get-date))
} | Out-Null

Register-ObjectEvent -InputObject $fileWatcher -EventName Changed -SourceIdentifier File.Changed -Action {
    $Global:t = $event
    Write-Host ("{2} File Changed: {0} on {1}" -f $event.SourceEventArgs.Name,
    (Split-Path $event.SourceEventArgs.FullPath),(get-date))
} | Out-Null

Register-ObjectEvent -InputObject $fileWatcher -EventName Renamed -SourceIdentifier File.Named -Action {
    $Global:t = $event
    Write-Host ("{2} File Named: {0} on {1}" -f $event.SourceEventArgs.Name,
    (Split-Path $event.SourceEventArgs.FullPath),(get-date))
} | Out-Null

#endregion Filesystem Watcher

#start-job {
#Register-EngineEvent -SourceIdentifier "file" -Forward
#New-Event -SourceIdentifier "file"
#}

#Register-EngineEvent -SourceIdentifier "file" -Action {write-host "blahblabhalbahbalskdfj"}


while ($true){start-sleep -milliseconds 50}
