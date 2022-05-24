write-host "======== Step: Generating PDF Report ========"
AppScanCMD.exe /r /b $scanFile /rt pdf /rf $reportPDFFile | out-null
write-host "Report file $reportPDFFile generated."
