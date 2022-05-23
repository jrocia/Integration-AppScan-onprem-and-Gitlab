write-host "======== Step: Publishing Assessment in ASE ========"
# Input variable: $scanFile, $aseAppName
# Output variable: $scanName

AppScanCMD.exe /r /b $scanFile /rt rc_ase /aan $aseAppName > scanName_var.txt

$outputContent=Get-Content .\scanName_var.txt
$scanName=$outputContent.Replace("`0","") | Select-String -Pattern "AppScan Enterprise job '(.*)'" | % {$_.Matches.Groups[1].Value}
write-host "File $scanFile (scan name $scanName) published on application $aseAppName on AppScan Enterprise." 

sleep 60;
