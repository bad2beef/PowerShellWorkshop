$Hso = New-Object Net.HttpListener
$Hso.Prefixes.Add("http://+:8000/")
$Hso.Start()
$p=2
$g=19
$r = [System.Random]::new()
$enc = [system.Text.Encoding]::UTF8
$sha1 = New-Object System.Security.Cryptography.SHA1CryptoServiceProvider 
$b= [math]::round($r.NextDouble() * 1000) % $p
$spub = [math]::pow($g,$b) % $p

function crypt($msg_bytes,$key_bytes){
    $i = 0
    $msg_bytes | % {
        $_ -bxor $key_bytes[($i%$key_bytes.Count)]
        $i ++
    }
}
function getchar($bytes){
    $asciipt = $bytes | % {
    [system.convert]::ToChar($_)
    }
    $asciipt -join $_
}

function decrypt($recv, $key_bytes){
    $pt = crypt -msg_bytes $recv -key_bytes $key_bytes
    $msg = getchar -bytes $pt
    $msg
}


While ($Hso.IsListening) {
    $HC = $Hso.GetContext()
    $HRes = $HC.Response
    if ($HC.Request.RawUrl -eq '/'){
        $Buf = [Text.Encoding]::UTF8.GetBytes('init')
        $HRes.ContentLength64 = $Buf.Length
        $HRes.OutputStream.Write($Buf,0,$Buf.Length)
        $HRes.Close()
    }
    if ($HC.Request.RawUrl -eq '/1'){
        $msg = @{'p'= $p;'g'=$g;'spub'=$spub}
        $Buf = [Text.Encoding]::UTF8.GetBytes(($msg | ConvertTo-Json))
        $HRes.ContentLength64 = $Buf.Length
        $HRes.OutputStream.Write($Buf,0,$Buf.Length)
        $HRes.Close()
    }

    if ($HC.Request.RawUrl -match '/2'){     
        [int]$cpub = ($HC.Request.QueryString.GetValues('cpub')) | Out-Null
        Write-Host $cpub
        $s2 = [math]::pow($cpub,$b)%$P
        $skey = [System.BitConverter]::ToString($sha1.ComputeHash($enc.GetBytes($s2)))
        $skey =$skey -replace'-',''
        write-host $skey
        $rsec= "this is a secret!"
        $rcrypt = crypt -msg_bytes $enc.getbytes($rsec) -key_bytes $enc.getbytes($skey) 
        $resp= [System.Convert]::ToBase64String($rcrypt)
        $Buf = [Text.Encoding]::UTF8.GetBytes($resp)
        $HRes.ContentLength64 = $Buf.Length
        $HRes.OutputStream.Write($Buf,0,$Buf.Length)
        $HRes.Close()
    }
}

#$Hso.Stop()