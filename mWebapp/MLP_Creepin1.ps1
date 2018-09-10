# TASK! 
# Measure penetration of MLP faggotry in other communities

$DebugPreference = "Continue"
$pf = gc MLP_list.txt

$fps = iwr 'https://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_National_Pok%C3%A9dex_number'
$guys = $fps.Links.href | select-string -SimpleMatch '_(Pok%C3%A9mon)' | Sort-Object -Unique 
$guys = $guys | %{$_.ToString().replace('/wiki/',"").replace('_(Pok%C3%A9mon)',"")}

$vusers=@()
$global:userdomain=@{}

function check-reddituser($name){
    $ruURL = 'https://www.reddit.com/user/{0}' -f $name
    try {
        $resp = iwr $ruURL
#        Write-Host "$name is valid!"
        return $name
    }
    catch {
#        Write-Debug "$name not found" 
    }
}

function get-commentdomain($name){
    $rcURL = 'https://www.reddit.com/user/{0}/comments?limit=100' -f $name
    try {
        $resp = iwr $rcURL
        $forums = $resp.Links.href | Select-String 'comments' | %{ ($_.tostring() -split '/')[2]} | Where-Object {$_ -notmatch 'reddit.com'}       
        write-debug "$forums were found!"
        $global:userdomain["$name"] = $forums
    }
    catch {
        Write-Debug "no comments found"
        $global:userdomain["$name"]='no comments'
    }
}

#measure-command {
#	$vusers = $guys | % {
#        	check-reddituser -name $_
#	}
#	Write-Debug ("Found {0} valid users" -f $vusers.Count)
#	write-Debug "wow, that was slow"
#}

#$vusers | %{
#    get-commentdomain -name $_
#}

#$allvals = $global:userdomain.Keys | %{$global:userdomain["$_"]}
#$allvals | Group-Object | Sort-Object -Property Count -Descending

#$global:userdomain.Keys | %{
#if ( $global:userdomain["$_"] -eq $null){
#    Write-Debug "$_ Has no posts"
#    }
#}

#########################
# Holy shit this is slow!
#########################

# Scope our function in a scriptblock
$cmd = {
    function check-reddituser($name){
        $ruURL = 'https://www.reddit.com/user/{0}' -f $name
        try {
            $resp = iwr $ruURL
#            Write-Host "$name is valid!"
            return $name
        }
        catch {
#            Write-Debug "$name not found" 
        }
    }
    $foo = check-reddituser -name $args[0]
}


#list of shit to do

measure-command{
$guys | %{
    start-job $cmd -argumentlist $_
}
$myresults = get-job | %{
    $_ | receive-job -wait
}
write-host "a little bit faster if it didnt crash us!"
}



$cmd = {
    function get-commentdomain2($name){
        $rcURL = 'https://www.reddit.com/user/{0}/comments?limit=100' -f $name
        try {
            $resp = iwr $rcURL
            $forums = $resp.Links.href | Select-String 'comments' | %{ ($_.tostring() -split '/')[2]} | Where-Object {$_ -notmatch 'reddit.com'}       
            return ($name, $forums)
        }
        catch {
            return ($name,'no comments')
        }
    }
    $foo = get-commentdomain2 -name $args[0]
}


