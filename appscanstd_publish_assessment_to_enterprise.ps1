write-host "======== Step 3 - Publishing Assessment ========"
AppScanCMD.exe /r /b $scanFile /rt rc_ase /aan $aseAppName > output.txt
sleep 60;
