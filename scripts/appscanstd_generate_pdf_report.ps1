write-host "======== Step: Generating PDF Report ========"
# Executing AppScan Standard to generate a PDF report based in a Scan File (.scan)
AppScanCMD.exe /r /b $scanFile /rt pdf /rf $reportPDFFile | out-null
write-host "Report file $reportPDFFile generated."
