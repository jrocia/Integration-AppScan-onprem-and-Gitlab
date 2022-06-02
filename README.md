# Integration AppScan Onprem and Gitlab<br>

This integration was based on previous work. Take a look into previous work to understand Requirements:<br>
https://github.com/jrocia/Integration-AppScanSTD-and-Gitlab<br>
https://github.com/jrocia/Integration-ASE-DAST-and-Gitlab PS: This new one works on Windows.<br> 
https://github.com/jrocia/Integration-AppScanSRC-and-Gitlab<br>

<br>
<b><p align="center">Gitlab-CI.YML:<br></b>

dast-std-gitlab-ci.yml<br>

![image](https://user-images.githubusercontent.com/69405400/171624855-e2a998c2-84e7-4331-b4a0-692d91bdd4e6.png)

sast-src-gitlab-ci.yml<br>
![image](https://user-images.githubusercontent.com/69405400/171052553-94a8864c-464a-4a18-bcf8-5e967101e75a.png)

dast-std-ase-gitlab-ci.yml<br>
![image](https://user-images.githubusercontent.com/69405400/171052601-57235dee-ba69-4af5-a609-361ca81ce438.png)

sast-src-ase-gitlab-ci.yml<br>
![image](https://user-images.githubusercontent.com/69405400/171052626-984b0fd1-4581-4bfa-bf65-dcc5f8976c8e.png)

dast-ase-gitlab-ci.yml<br>
![image](https://user-images.githubusercontent.com/69405400/171052657-c04fec45-fece-4f0a-b1e4-e0c72219d610.png)
</p>

<br>

Scripts:<br>
scripts/appscanase_scan.ps1<br>
scripts/appscansrc_scan.ps1<br>
scripts/appscanstd_scan.ps1<br>
scripts/appscanase_create_application_ase.ps1<br>
scripts/appscansrc_create_config_scan_file.ps1<br>
scripts/appscanstd_generate_pdf_report.ps1<br>
scripts/appscansrc_publish_assessment_to_enterprise.ps1<br>
scripts/appscanstd_publish_assessment_to_enterprise.ps1<br>
scripts/appscanase_get_pdf_report_from_enterprise.ps1<br>
scripts/appscanase_get_xml_report_from_enterprise.ps1<br>
scripts/appscanase_convert_ase_dast_xml_to_gitlab_json.ps1<br>
scripts/appscanase_convert_ase_sast_xml_to_gitlab_json.ps1<br>
scripts/appscanase_check_security_gate.ps1<br>
scripts/appscansrc_check_security_gate.ps1<br>
scripts/appscanstd_check_security_gate.ps1<br>

<br>

![image](https://user-images.githubusercontent.com/69405400/171626936-504f9d04-73dc-4410-aa91-050055b26ee7.png)

