$r = [System.Random]::new()
$enc = [system.Text.Encoding]::UTF8
$sha1 = New-Object System.Security.Cryptography.SHA1CryptoServiceProvider 

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

$skey=$skey -replace '-',''
$skey

irm "http://localhost:8000/2?cpub=$cpub"