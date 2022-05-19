write-host "======== Step 3 - Publishing Assessment ========"
AppScanCMD.exe /r /b $scanFile /rt rc_ase /aan $aseAppName > output.txt
write-host "File $scanFile published on application $aseAppName on AppScan Enterprise." 
sleep 60;
