###########################################
# https://cryptopals.com/sets/5/challenges/33
###########################################
$p = 'ffffffffffffffffc90fdaa22168c234c4c6628b80dc1cd129024e088a67cc74020bbea63b139b22514a08798e3404ddef9519b3cd3a431b302b0a6df25f14374fe1356d6d51c245e485b576625e7ec6f44c42e9a637ed6b0bff5cb6f406b7edee386bfb5a899fa5ae9f24117c4b1fe649286651ece45b3dc2007cb8a163bf0598da48361c55d39a69163fa8fd24cf5f83655d23dca3ad961c62f356208552bb9ed529077096966d670c354e4abc9804f1746c08ca237327ffffffffffffffff'
$enc = [system.Text.Encoding]::UTF8
$p=$enc.GetBytes($p)
$p= [bitconverter]::ToInt64($p,0)
$g = 2
#$r = [System.Random]::new()
#$sha1 = New-Object System.Security.Cryptography.SHA1CryptoServiceProvider 
#$a= [math]::round($r.Next(1,1000)) % $p
$a= ($r.Next(1,1000)*10000000000000000000000) % $p
$bigA = [math]::pow($g,$a) % $0p
#$b= [math]::round($r.Next(1,1000)) % $p
$b= ($r.Next(1,1000)*10000000000000000000000) % $p
$bigB = [math]::pow($g,$b) % $p
$s1 = [math]::pow($bigB,$a)%$P
$s2 = [math]::pow($bigA,$b)%$P
$skey1 = [System.BitConverter]::ToString($sha1.ComputeHash($enc.GetBytes($s1)))
$skey2 = [System.BitConverter]::ToString($sha1.ComputeHash($enc.GetBytes($s2)))
$skey1
$skey2