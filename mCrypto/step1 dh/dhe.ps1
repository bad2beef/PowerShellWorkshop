###########################################
# https://cryptopals.com/sets/5/challenges/33
###########################################
$p = 37
$g = 5
$r = [System.Random]::new()
$enc = [system.Text.Encoding]::UTF8
$sha1 = New-Object System.Security.Cryptography.SHA1CryptoServiceProvider 
$a= [math]::round($r.NextDouble() * 1000) % $p
$bigA = [math]::pow($g,$a) % $p
$b= [math]::round($r.NextDouble() * 1000) % $p
$bigB = [math]::pow($g,$b) % $p
$s1 = [math]::pow($bigB,$a)%$P
$s2 = [math]::pow($bigA,$b)%$P
$skey1 = [System.BitConverter]::ToString($sha1.ComputeHash($enc.GetBytes($s1)))
$skey2 = [System.BitConverter]::ToString($sha1.ComputeHash($enc.GetBytes($s2)))
$skey1
$skey2