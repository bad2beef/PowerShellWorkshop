$r = [System.Random]::new()
$enc = [system.Text.Encoding]::UTF8
$sha1 = New-Object System.Security.Cryptography.SHA1CryptoServiceProvider 

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

$0= irm 'http://localhost:8000'
$1= irm 'http://localhost:8000/1'

if ($1){
    $g = $1.g
    $p= $1.p
    $spub = $1.spub
}



$a= [math]::round($r.NextDouble() * 1000) % $p
$cpub = [math]::pow($g,$a) % $p
$msg = @{'ckey'= $cpub}
$sess = [math]::pow($spub,$a)%$P
$skey = [System.BitConverter]::ToString($sha1.ComputeHash($enc.GetBytes($sess)))

Write-Host $spub

$skey=$skey -replace '-',''
$skey

$resp = irm "http://localhost:8000/2?cpub=$cpub" 

$resp_bytes = [System.Convert]::FromBase64String($resp)
crypt -msg_bytes $resp_bytes -key_bytes $enc.GetBytes($skey)