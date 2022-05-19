write-host "======== Step 2 - Generating PDF Report ========"
AppScanCMD.exe /r /b $scanFile /rt pdf /rf $reportPDFFile | out-null
write-host "======== Step 2 finished ========"
