write-host "======== Step 3 - Publishing Assessment ========"
AppScanCMD.exe /r /b $scanFile /rt rc_ase /aan $aseAppName > output.txt
$outputContent=Get-Content .\output.txt
$scanName=$outputContent.Replace("`0","") | Select-String -Pattern "AppScan Enterprise job '(.*)'" | % {$_.Matches.Groups[1].Value}
write-host "File $scanFile (scan name $scanName) published on application $aseAppName on AppScan Enterprise." 
sleep 60;
