write-host "======== Step 3 - Publishing Assessment ========"
AppScanCMD.exe /r /b $scanFile /rt rc_ase /aan $aseAppName > output.txt
$outputContent=Get-Content .\output.txt
$scanName=$outputContent.Replace("`0","") | Select-String -Pattern "AppScan Enterprise job '(.*)'" | % {$_.Matches.Groups[1].Value}
echo "The scan name is $scanName"
sleep 60;
