# Socket stuff
$tcpConnection = New-Object System.Net.Sockets.TcpClient($FTPServer, $FTPPort)
$tcpStream = $tcpConnection.GetStream()
$reader = New-Object System.IO.StreamReader($tcpStream)
$writer = New-Object System.IO.StreamWriter($tcpStream)
$writer.AutoFlush = $true

$buffer = new-object System.Byte[] 1024
$encoding = new-object System.Text.AsciiEncoding 

while ($tcpConnection.Connected)
{
    while ($tcpStream.DataAvailable)
    {

        $rawresponse = $reader.Read($buffer, 0, 1024)
        $response = $encoding.GetString($buffer, 0, $rawresponse)   
    }

    if ($tcpConnection.Connected)
    {
        Write-Host -NoNewline "prompt> "
        $command = Read-Host

        if ($command -eq "escape")
        {
            break
        }

        $writer.WriteLine($command) | Out-Null
    }
    start-sleep -Milliseconds 500
}

$reader.Close()
$writer.Close()
$tcpConnection.Close()