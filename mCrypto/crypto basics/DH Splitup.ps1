###########################################
# Client Code
###########################################
$msg1 = @{'p'= 2;'g'= 19}
$r = [System.Random]::new()
$enc = [system.Text.Encoding]::UTF8
$sha1 = New-Object System.Security.Cryptography.SHA1CryptoServiceProvider 
$a= [math]::round($r.NextDouble() * 1000) % $p
$bigA = [math]::pow($g,$a) % $p

###########################################
# Server Code
###########################################
$msg1 = @{'p'= 2;'g'=19}
$r = [System.Random]::new()
$enc = [system.Text.Encoding]::UTF8
$sha1 = New-Object System.Security.Cryptography.SHA1CryptoServiceProvider 
$b= [math]::round($r.NextDouble() * 1000) % $p
$bigB = [math]::pow($g,$b) % $p

$msg2 = @{'bigA'= $bigA}
$s2 = [math]::pow($bigA,$b)%$P
$skey2 = [System.BitConverter]::ToString($sha1.ComputeHash($enc.GetBytes($s2)))
$skey2 -replace '-',''

###########################################
# Client Code
###########################################
$msg2 = @{'bigB'= $bigB}
$s1 = [math]::pow($bigB,$a)%$P
$skey1 = [System.BitConverter]::ToString($sha1.ComputeHash($enc.GetBytes($s1)))
$skey1 -replace '-',''