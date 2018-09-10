# TASK! 
# Measure penetration of MLP faggotry in other communities

$DebugPreference = "Continue"
$fps = iwr 'https://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_National_Pok%C3%A9dex_number'
$guys = $fps.Links.href | select-string -SimpleMatch '_(Pok%C3%A9mon)' | Sort-Object -Unique 
$guys = $guys | %{$_.ToString().replace('/wiki/',"").replace('_(Pok%C3%A9mon)',"")}

# Scope our function in a scriptblock so it can be injected into a runspace
$cmd = {
    function check-reddituser($name){
        $ruURL = 'https://www.reddit.com/user/{0}' -f $name
        try {
            $resp = iwr $ruURL
	    #write-host $resp
            return $name
#	    return New-Object -TypeName PSCustomObject -Property @{Output=$output; ExitCode=$exitCode}
        }
        catch {
            return "$name not found" 
#	    return New-Object -TypeName PSCustomObject -Property @{Output=$output; ExitCode=$exitCode}
        }
    }
    check-reddituser -name $args[0]
#    $foo
}

####################################
# Speed it up, dont crash the system
####################################
# Read the input and queue it up
$maxConcurrentJobs = 20

$jobInput = $guys

$q = [System.Collections.Queue]::Synchronized( (New-Object System.Collections.Queue) )
$rq = [System.Collections.Queue]::Synchronized( (New-Object System.Collections.Queue) )

$jobInput[0..10] | %{
    $q.Enqueue($_)
}

# Function that pops input off the queue and starts a job with it
function RunJobFromQueue
{
    if( $q.Count -gt 0)
    {
        $j = Start-Job -ScriptBlock $cmd -ArgumentList $q.Dequeue()
        Register-ObjectEvent -InputObject $j -EventName StateChanged -Action {
	$rq.Enqueue((receive-job -job $eventsubscriber.SourceObject)); 
	RunJobFromQueue; 
	Unregister-Event $eventsubscriber.SourceIdentifier; 
	Remove-Job $eventsubscriber.SourceIdentifier } | Out-Null
    }
}
# Start up to the max number of concurrent jobs
# Each job will take care of running the rest

for( $i = 0; $i -lt $maxConcurrentJobs; $i++ )
{
    RunJobFromQueue
}

while ($true){}

write-host $q
write-host $rq
