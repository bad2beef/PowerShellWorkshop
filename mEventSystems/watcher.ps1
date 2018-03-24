#region Filesystem Watcher

if ($env:os -eq 'Windows_NT'){
$fileWatcher.Path = "C:\temp\"
}
elseif ($env:os -eq 'osx'){

}
elseif ($env:os -eq 'linux'){

}

$fileWatcher.Path = "C:\temp\"

if (!(Test-Path C:\temp)){
    mkdir C:\temp
}

if (!(Test-Path C:\temp)){
    mkdir C:\temp
}

$fileWatcher = New-Object System.IO.FileSystemWatcher

$fileWatcher.Path = "C:\temp\"

Register-ObjectEvent -InputObject $fileWatcher -EventName Created -SourceIdentifier File.Created -Action {
    $Global:t = $event
    Write-Host ("File Created: {0} on {1}" -f $event.SourceEventArgs.Name,
    (Split-Path $event.SourceEventArgs.FullPath))
} | Out-Null

Register-ObjectEvent -InputObject $fileWatcher -EventName Deleted -SourceIdentifier File.Deleted -Action {
    $Global:t = $event
    Write-Host ("File Deleted: {0} on {1}" -f $event.SourceEventArgs.Name,
    (Split-Path $event.SourceEventArgs.FullPath))
} | Out-Null

Register-ObjectEvent -InputObject $fileWatcher -EventName Changed -SourceIdentifier File.Changed -Action {
    $Global:t = $event
    Write-Host ("File Changed: {0} on {1}" -f $event.SourceEventArgs.Name,
    (Split-Path $event.SourceEventArgs.FullPath))
} | Out-Null

Register-ObjectEvent -InputObject $fileWatcher -EventName Renamed -SourceIdentifier File.Named -Action {
    $Global:t = $event
    Write-Host ("File Named: {0} on {1}" -f $event.SourceEventArgs.Name,
    (Split-Path $event.SourceEventArgs.FullPath))
} | Out-Null

#endregion Filesystem Watcher

start-job {
Register-EngineEvent -SourceIdentifier "file" -Forward
New-Event -SourceIdentifier "file"
}

Register-EngineEvent -SourceIdentifier "file" -Action {write-host "blahblabhalbahbalskdfj"}