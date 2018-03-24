Import-Module posh-ssh
$hostos = "dunno"
$creds = Get-Credential
$username = $creds.GetNetworkCredential().UserName
$supass = $creds.GetNetworkCredential().Password
$DebugPreference = "Continue"
$nixcreds = New-Object System.Management.Automation.PSCredential ($creds.GetNetworkCredential().UserName, $creds.Password)
$hostlist = "10.10.89.78"

function sle {
    sleep -milliseconds 100
}

#System.IO.Stream

#function get-nixport ($hostlist,$creds){

$cmds = "cat /etc/passwd", "cat /etc/sudoers", "ifconfig", "cat /etc/resolv.conf", "netstat -anp"

    $session = New-SSHSession -ComputerName $hostlist -AcceptKey -Credential $nixcreds
    $stream = New-SSHShellStream -SessionId $session.sessionid
    $stream.read() | Out-Null
    sle
    $stream.WriteLine("sudo su -")
    $stream.Expect("password for $username")
    $stream.WriteLine("$supass")
    sle
    $results = $cmds | % {
        $stream.WriteLine("$_")
        sle
        $cmdoutput = $stream.Read()
        $guy = New-Object psobject
        $guy | Add-Member -MemberType NoteProperty -Name "cmd" -Value $_
        $guy | Add-Member -MemberType NoteProperty -Name "output" -Value $cmdoutput
        return $guy
        }



    $stream.WriteLine("cat /etc/sudoers")
    sle
    $sudoers = $stream.Read()
    sle
    $stream.WriteLine("cat /etc/ssh/sshd_config")
    sle
    $sshdconf = $stream.Read()

    $dataz = while ($stream.DataAvailable -eq "True"){$stream.readline()}
    $dataz = while ($stream.DataAvailable -eq "True"){$stream.read()}
    if ($dataz | Select-String -simplematch "[sudo] password for $username"){
        $stream.WriteLine("$supass")
    }
    $dataz = $stream.Read() #while ($stream.DataAvailable){$stream.read()}
    if ($dataz | Select-String -simplematch "root@"){
        $stream.WriteLine("netstat -anp")
        $dataz = $stream.read() #while ($stream.DataAvailable){$stream.read()}
        return $dataz
    }
}




    $session = New-SSHSession -ComputerName $hostlist -AcceptKey -Credential $nixcreds
    $stream = New-SSHShellStream -SessionId $session.sessionid
    sle
    $stream.read() | Out-Null
    sle
    $stream.WriteLine("sudo cat /etc/sudoers")
    $dataz = $stream.readline()
    sle
    $stream.Read() | Out-Null
    sle
    $stream.WriteLine("$supass")
    $stream.Read() | Out-Null
    $stream.WriteLine("cat /etc/sudoers")
    sle
    $sudoers = $stream.Read()