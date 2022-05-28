write-host "======== Step: Checking Security Gate ========"

[XML]$xml=Get-Content ./$artifactName.ozasmt
$highIssues = $xml.AssessmentRun.AssessmentStats.total_high_finding
$mediumIssues = $xml.AssessmentRun.AssessmentStats.total_med_finding
$lowIssues = $xml.AssessmentRun.AssessmentStats.total_low_finding
$totalIssues = $highIssues+$mediumIssues+$lowIssues

write-host "There is $highIssues high issues, $mediumIssues medium issues and $lowIssues low issues."
write-host "The company policy permit less than $maxIssuesAllowed $sevSecGw severity."

if (( $highIssues -gt $maxIssuesAllowed ) -and ( "$sevSecGw" -eq "highIssues" )) {
  write-host "$highIssues greater than $maxIssuesAllowed and $sevSecGw equals highIssues"
  write-host "High";
  write-host "Security Gate build failed";
  exit 1
  }
elseif (( $mediumIssues -gt $maxIssuesAllowed ) -and ( "$sevSecGw" -eq "mediumIssues" )) {
  write-host "Medium";
  write-host "Security Gate build failed";
  exit 1
  }
elseif (( $lowIssues -gt $maxIssuesAllowed ) -and ( "$sevSecGw" -eq "lowIssues" )) {
  write-host "Low";
  write-host "Security Gate build failed";
  exit 1
  }
elseif (( $totalIssues -gt $maxIssuesAllowed ) -and ( "$sevSecGw" -eq "totalIssues" )) {
  write-host "total";
  write-host "Security Gate build failed";
  exit 1
  }
else{
write-host "Security Gate passed"
  }
