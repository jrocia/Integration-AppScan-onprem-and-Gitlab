write-host "======== Step 1 - Running scan in $url ========"
if ( [string]::IsNullOrWhiteSpace($manualExplore) ){
  echo "There is no manual explorer file in $CI_PROJECT_DIR\manualexplore.exd";
  AppScanCMD.exe /su $url /d $scanFile /rt xml /rf $reportXMLsevSec
  }
else{
  echo "There is a manual explorer file $manualExplore";
  AppScanCMD.exe /su $url /d $scanFile /rt xml /rf $reportXMLsevSec /mef $manualExplore /to
  }
