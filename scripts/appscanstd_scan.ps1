write-host "======== Step: Running scan in $url ========"
if ((Test-Path -Path $manualExploreDastConfig -PathType Leaf) -and (Test-Path -Path $loginDastConfig -PathType Leaf)){
  write-host "Manual explorer and login file were found in repository folder. It will be used in scanning process."
  AppScanCMD.exe /su $url /d $scanFile /rt xml /rf $reportXMLsevSec /mef $manualExploreDastConfig /to /lf $loginDastConfig
  }
elseif ((Test-Path -Path $manualExploreDastConfig -PathType Leaf)){
  write-host "Manual explorer file was found in repository folder. It will be used in scanning process."
  AppScanCMD.exe /su $url /d $scanFile /rt xml /rf $reportXMLsevSec /mef $manualExploreDastConfig /to
  }
elseif ((Test-Path -Path $loginDastConfig -PathType Leaf)){
  write-host "Login file was found in repository folder. It will be used in scanning process."
  AppScanCMD.exe /su $url /d $scanFile /rt xml /rf $reportXMLsevSec /lf $loginDastConfig
  }
else{
  write-host "There is no Login or Manual Explorer file in repository folder."
  AppScanCMD.exe /su $url /d $scanFile /rt xml /rf $reportXMLsevSec
  }
write-host "Scan on $url finished."
