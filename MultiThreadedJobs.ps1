$Jobs =
("Windows Activation",
{
    $ActivationData = Get-CimInstance -ClassName SoftwareLicensingProduct | where {$_.PartialProductKey} | select Description, LicenseStatus

    if ($ActivationData.Description -like "*Operating System*") 
    {
        return "OS is activated"
    } 
    else 
    {
        return "OS is not activated"
    }
}
),
("Placeholder Timer",
{
    Start-Sleep 5
    return "Timer is Done"
}
)

$jobStats = New-Object System.Collections.Generic.List[System.Object]

foreach ($job in $Jobs) {
    $Currentjob = start-job -scriptblock $Job[1]
    $jobStats.Add(($Job[0],$Currentjob))
}

$isJobFinished = New-Object System.Collections.Generic.List[System.Object]

while ($true) { 
    $isJobFinished.Clear()

    foreach ($job in $jobStats) {
        if ($job[1].JobStateInfo.ToString() -eq "Running") {
            Write-Host "Waiting For jobs"
            $isJobFinished.Add($false)
        } else {
            Write-Host "Done with" $job[0]
            $isJobFinished.Add($true)
            Receive-Job -job $job[1]
        }
    }

    Start-Sleep 1
    if ($isJobFinished -notcontains $false) {
        break
    }
     
}

Write-Host "All Done."




