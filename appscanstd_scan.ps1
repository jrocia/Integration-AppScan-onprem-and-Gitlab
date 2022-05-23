write-host "======== Step: Running scan in $url ========"
if ([System.IO.File]::Exists($manualExploreDastConfig) -and [System.IO.File]::Exists($loginDastConfig)){
  write-host "Manual explorer and login file were found in repository folder. It will be used in scanning process."
  AppScanCMD.exe /su $url /d $scanFile /rt xml /rf $reportXMLsevSec /mef $manualExploreDastConfig /to /lf $loginDastConfig
  }
elseif ([System.IO.File]::Exists($manualExploreDastConfig)){
  write-host "Manual explorer file was found in repository folder. It will be used in scanning process."
  AppScanCMD.exe /su $url /d $scanFile /rt xml /rf $reportXMLsevSec /mef $manualExploreDastConfig /to
  }
elseif ([System.IO.File]::Exists($loginDastConfig)){
  write-host "Login file was found in repository folder. It will be used in scanning process."
  AppScanCMD.exe /su $url /d $scanFile /rt xml /rf $reportXMLsevSec /lf $loginDastConfig
  }
else{
  AppScanCMD.exe /su $url /d $scanFile /rt xml /rf $reportXMLsevSec
  }
write-host "Scan on $url finished."
