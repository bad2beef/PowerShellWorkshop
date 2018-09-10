# TASK! 
# Measure penetration of MLP faggotry in other communities

$DebugPreference = "Continue"
$pf = gc C:\tools\PowerShellWorkshop\mWebapp\MLP_list.txt

$fps = iwr 'https://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_National_Pok%C3%A9dex_number'
$guys = $fps.Links.href | select-string -SimpleMatch '_(Pok%C3%A9mon)' | Sort-Object -Unique 
$guys = $guys | %{$_.ToString().replace('/wiki/',"").replace('_(Pok%C3%A9mon)',"")}

# Mutate for coverage
#$pf += gc C:\tools\hashcat-4.1.0\pokeman2.txt
#$rs = iwr "https://www.reddit.com/users/popular?limit=100"
#$top100 = $rs.links.href | Where-Object {$_ -match '/user/'} | Split-Path -Leaf
#$name = "ranok"


$vusers=@()
$global:userdomain=@{}

function check-reddituser($name){
    $ruURL = 'https://www.reddit.com/user/{0}' -f $name
    try {
        $resp = iwr $ruURL
        Write-Host "$name is valid!"
        return $name
    }
    catch {
        Write-Debug "$name not found" 
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

$vusers = $guys | % {
    check-reddituser -name $_
}

Write-Debug ("Found {0} valid users" -f $vusers.Count)

$vusers | %{
    get-commentdomain -name $_
}

$allvals = $global:userdomain.Keys | %{$global:userdomain["$_"]}
$allvals | Group-Object | Sort-Object -Property Count -Descending

$global:userdomain.Keys | %{
if ( $global:userdomain["$_"] -eq $null){
    Write-Debug "$_ Has no posts"
    }
}


#########################
# Holy shit this is slow!
#########################

# Scope our function in a scriptblock
$cmd = {
    function check-reddituser($name){
        $ruURL = 'https://www.reddit.com/user/{0}' -f $name
        try {
            $resp = iwr $ruURL
            Write-Host "$name is valid!"
            return $name
        }
        catch {
            Write-Debug "$name not found" 
        }
    }
    $foo = check-reddituser -name $args[0]
}


#list of shit to do
$guys[0..10] | %{
    start-job $cmd -argumentlist $_
}

$myresults = get-job | %{
    $_ | receive-job -wait
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


