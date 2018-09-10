# How many jobs we should run simultaneously
$maxConcurrentJobs = 20;


# Read the input and queue it up
$jobInput = '8.8.8.8', '4.2.2.2', '6.6.6.6', '1.1.1.1', '4.4.4.4', '9.9.9.9', 'www.google.com', 'www.yahoo.com'
$queue = [System.Collections.Queue]::Synchronized( (New-Object System.Collections.Queue) )
$rq = [System.Collections.Queue]::Synchronized( (New-Object System.Collections.Queue) )

foreach($item in $jobInput)
{
    $queue.Enqueue($item)
}

# Function that pops input off the queue and starts a job with it

function RunJobFromQueue
{
    if( $queue.Count -gt 0)
    {
        $j = Start-Job -ScriptBlock {Test-Connection -ComputerName $args[0]} -ArgumentList $queue.Dequeue()
        Register-ObjectEvent -InputObject $j -EventName StateChanged -Action { $rq.Enqueue((Receive-Job -job $eventsubscriber.SourceObject)) ; RunJobFromQueue; Unregister-Event $eventsubscriber.SourceIdentifier; Remove-Job $eventsubscriber.SourceIdentifier; Remove-Job $eventsubscriber.sourceobject } | Out-Null
    }
} 

# Start up to the max number of concurrent jobs
# Each job will take care of running the rest


for( $i = 0; $i -lt $maxConcurrentJobs; $i++ )
{
    RunJobFromQueue
}