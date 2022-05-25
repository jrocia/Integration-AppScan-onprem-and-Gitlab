write-host "======== Step: Running scan in $artifactName ========"

AppScanSrcCli scr script.scan
copy $artifactFolder\$artifactName.ozasmt .
