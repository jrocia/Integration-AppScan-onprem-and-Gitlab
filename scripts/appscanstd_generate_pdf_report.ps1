# Copyright 2023 HCL America
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

write-host "======== Step: Generating PDF Report ========"
# Executing AppScan Standard to generate a PDF report based in a Scan File (.scan)
AppScanCMD.exe /r /b $scanFile /rt pdf /rf $reportPDFFile | out-null
write-host "Report file $reportPDFFile generated."
