# https://cryptopals.com/sets/1 
$enc = [system.Text.Encoding]::UTF8
$msg = "hello world"
$key = "foo" 
$key_bytes = $enc.GetBytes($key)
$msg_bytes = $enc.GetBytes($msg) 
function crypt($msg_bytes,$key_bytes){
# For each byte in plaintext array, BXOR with the key bytes in rotation
# Same function decrypts with the same key
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
# Conducts decrypt and ASCII cast for brevity
    $pt = crypt -msg_bytes $recv -key_bytes $key_bytes
    $msg = getchar -bytes $pt
    $msg
}

$secretZ = crypt -msg_bytes $msg_bytes -key_bytes $key_bytes
$http = [System.Convert]::ToBase64String($secretZ) # Binary secret is now B64 for HTTP transmission (or any other protocol)
########################################################### Illustrates communication barrier, client to server message passing or vice versa
$recv = [System.Convert]::FromBase64String($http) # Decode B64 msg back to bytes
$plaintext = crypt -msg_bytes $recv -key_bytes $key_bytes # BXOR ciphertext with same Preshared key
$decr = getchar -bytes $plaintext # Cast bytes as ASCII data
# Unit tests 
Write-Host "KEY: $key"
Write-Host "MSG: $msg"
Write-Host "DECRYPTED_MSG: $decr"

decrypt -recv $recv -key_bytes $key_bytes