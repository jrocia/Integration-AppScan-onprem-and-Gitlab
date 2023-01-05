write-host "======== Step: Running scan in $artifactName ========"
# Running AppScan Source scan through AppScanSrcCli
AppScanSrcCli scr script.scan
# copy $artifactFolder\$artifactName.ozasmt .
