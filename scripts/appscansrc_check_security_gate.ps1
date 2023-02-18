write-host "======== Step: Checking Security Gate ========"
# Loading ozasmt (AppScan Source result scan file) file into a variable
[XML]$xml=Get-Content $artifactFolder/$artifactName.ozasmt
[int]$highIssues = $xml.AssessmentRun.AssessmentStats.total_high_finding
[int]$mediumIssues = $xml.AssessmentRun.AssessmentStats.total_med_finding
[int]$lowIssues = $xml.AssessmentRun.AssessmentStats.total_low_finding
[int]$totalIssues = $highIssues+$mediumIssues+$lowIssues
$maxIssuesAllowed = $maxIssuesAllowed -as [int]

write-host "There is $highIssues high issues, $mediumIssues medium issues and $lowIssues low issues."
write-host "The company policy permit less than $maxIssuesAllowed $sevSecGw severity."

if (( $highIssues -gt $maxIssuesAllowed ) -and ( "$sevSecGw" -eq "highIssues" )) {
  write-host "Security Gate build failed";
  exit 1
  }
elseif (( $mediumIssues -gt $maxIssuesAllowed ) -and ( "$sevSecGw" -eq "mediumIssues" )) {
  write-host "Security Gate build failed";
  exit 1
  }
elseif (( $lowIssues -gt $maxIssuesAllowed ) -and ( "$sevSecGw" -eq "lowIssues" )) {
  write-host "Security Gate build failed";
  exit 1
  }
elseif (( $totalIssues -gt $maxIssuesAllowed ) -and ( "$sevSecGw" -eq "totalIssues" )) {
  write-host "Security Gate build failed";
  exit 1
  }
else{
write-host "Security Gate passed"
  }
# If you want to delete every files after execution
# Remove-Item -path $CI_PROJECT_DIR\* -recurse -exclude *.pdf,*.json,*.xml
