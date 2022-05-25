write-host "======== Step: Publishing Assessment in ASE ========"

write-output "login_file $aseHostname $aseToken -acceptssl" > scriptpase.scan
write-output "RUNAS AUTO" >> scriptpase.scan
write-output "publishassessase $artifactFolder\$artifactName.ozasmt -aseapplication $aseAppName -name $artifactName-$CI_JOB_ID" >> scriptpase.scan
write-output "exit" >> scriptpase.scan

AppScanSrcCli scr scriptpase.scan

write-host "Scan published in app "$aseAppName" in ASE"
