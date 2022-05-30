# Integration AppScan Onprem and Gitlab<br>

This integration was based on previous work. Take a look into previous work to understand Requirements:<br>
https://github.com/jrocia/Integration-AppScanSTD-and-Gitlab<br>
https://github.com/jrocia/Integration-ASE-DAST-and-Gitlab<br>
https://github.com/jrocia/Integration-AppScanSRC-and-Gitlab<br>

<br>
Gitlab-CI.YML:<br>
dast-std-gitlab-ci.yml<br>
sast-src-gitlab-ci.yml<br>
dast-std-ase-gitlab-ci.yml<br>
sast-src-ase-gitlab-ci.yml<br>
dast-ase-gitlab-ci.yml<br>
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
