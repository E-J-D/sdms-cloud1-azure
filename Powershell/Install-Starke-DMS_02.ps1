# 22.11.2022 Eike Doose / INTERNAL USER ONLY / do not distribute
# ============================================================================
#
# -FTPserver
#  > specify the FTP server which will be used for downloading the software / e.g. -FTPserver 'ftp.get--it.de'
#
# -FTPuser
#  > name the FTP server user for logging into the FTP server / e.g. -FTPuser 'username'
# 
# -FTPpass
#  > password for logging into the FTP server / e.g. -FTPpass 'verysecretpassword'
#
# -customerno
#  > client customer number which is needed for naming the new server and the database creation / e.g. -customerno '23545'
#
# -LIZuser
#  > username for using the license server / e.g. -LIZuser 'username'
#
# -LIZpass
#  > password for logging into the license server / e.g. -FTPpass 'licenseuserpass'
#
# -LIZserver
#  > URL of the license server / e.g. -LIZserver 'license.starke.cloud'
#
# -LIZuid
#  > license UID to be downloaded / e.g. -LIZuid '{5C395FDC-6A94-32BE-BAD4-918D9B324AFG}'
#
# -LIZcustomerno
#  > license custom number to be downloaded / e.g. -LIZcustomerno '23545'
#  > not needed if LIZuid is given
#
# -LIZtargetdir
#  > directory to where the license file will be downloaded / e.g. -LIZtargetdir 'd:\dms-config' 
#
# -saPass
#  > sa password for the database / e.g. -saPass 'secretsapassword' 
#
#
# parameter sample

# 25.04.2022 Eike Test NFR // CLOUD1MASTER1 50999 {5F900818-7977-4134-A741-2022C8059A5C}
# .\Install-Starke-DMS_02.ps1 -FTPserver '192.168.120.11' -FTPuser 'get--IT' -FTPpass 'get--IT2022' -customerno '50999' -LIZuser 'dockersetup' -LIZpass 'S3VyendlaWwgUmV2aXZhbCBiZXdlaXNlbiE' -LIZserver 'https://starke-dms-license.azurewebsites.net' -LIZuid '{5F900818-7977-4134-A741-2022C8059A5C}' -LIZtargetdir 'd:\dms-config' -saPass 'saAdmin00!' 

# 25.04.2022 Eike Test NFR
# Test Kunde 01 / {BB2D87B2-812D-4C62-BA40-7944B941B086} Test Kunde 01 / KDNR 56999
# .\Install-Starke-DMS_02.ps1 -FTPserver '192.168.120.11' -FTPuser 'get--IT' -FTPpass 'get--IT2022' -customerno '56999' -LIZuser 'dockersetup' -LIZpass 'S3VyendlaWwgUmV2aXZhbCBiZXdlaXNlbiE' -LIZserver 'https://starke-dms-license.azurewebsites.net' -LIZuid '{BB2D87B2-812D-4C62-BA40-7944B941B086}' -LIZtargetdir 'd:\dms-config' -saPass 'saAdmin00!' 

# 25.04.2022 Eike Test NFR
# Test Kunde 02 / {7666BBC5-7C53-4B17-9444-1CB0B707AF5C} Test Kunde 02 / KDNR 57999
# .\Install-Starke-DMS_02.ps1 -FTPserver '192.168.120.11' -FTPuser 'get--IT' -FTPpass 'get--IT2022' -customerno '57999' -LIZuser 'dockersetup' -LIZpass 'S3VyendlaWwgUmV2aXZhbCBiZXdlaXNlbiE' -LIZserver 'https://starke-dms-license.azurewebsites.net' -LIZuid '{7666BBC5-7C53-4B17-9444-1CB0B707AF5C}' -LIZtargetdir 'd:\dms-config' -saPass 'saAdmin00!' 

# 15.11.2022 Eike Test PRODUKTIV
# Test Kunde 02 / {7666BBC5-7C53-4B17-9444-1CB0B707AF5C} Test Kunde 02 / KDNR 57999
# .\Install-Starke-DMS_02.ps1 -FTPserver '172.28.0.11' -FTPuser 'AUTOINSTALLER' -FTPpass 'wbutJzGFALFDrtmN' -customerno '57999' -LIZuser 'dockersetup' -LIZpass 'S3VyendlaWwgUmV2aXZhbCBiZXdlaXNlbiE' -LIZserver 'https://starke-dms-license.azurewebsites.net' -LIZuid '{7666BBC5-7C53-4B17-9444-1CB0B707AF5C}' -LIZtargetdir 'd:\dms-config' -saPass 'saAdmin00!' 

# 22.11.2022 Eike Test VMware Testumgebung lokal
# Test Kunde 02 / {7666BBC5-7C53-4B17-9444-1CB0B707AF5C} Test Kunde 02 / KDNR 57999
# .\Install-Starke-DMS_02.ps1 -FTPserver '192.168.224.188' -FTPuser 'hausmeister' -FTPpass 'hausmeister' -customerno '57999' -LIZuser 'dockersetup' -LIZpass 'S3VyendlaWwgUmV2aXZhbCBiZXdlaXNlbiE' -LIZserver 'https://starke-dms-license.azurewebsites.net' -LIZuid '{7666BBC5-7C53-4B17-9444-1CB0B707AF5C}' -LIZtargetdir 'd:\dms-config' -saPass 'saAdmin00!' 



param (
	[string]$FTPserver = '172.28.0.11',
	[Parameter(Mandatory=$true)][string]$FTPuser,
	[Parameter(Mandatory=$true)][string]$FTPpass,
	[Parameter(Mandatory=$true)][string]$customerno,
	[Parameter(Mandatory=$true)][string]$LIZuser,
	[Parameter(Mandatory=$true)][string]$LIZpass,
	[string]$LIZserver = 'https://starke-dms-license.azurewebsites.net',
	[Parameter(Mandatory=$true)][string]$LIZuid,
	[string]$LIZtargetdir = 'd:\dms-config',
	[string]$LIZcustomerno,
	[Parameter(Mandatory=$true)][string]$saPass
)

# ============================================================================

################################################
## stop script on PowerShell error 
################################################
$ErrorActionPreference = "Stop"

################################################
## detect Powershe version - minimum 7
################################################
If ($PSVersionTable.PSVersion.Major -lt 7) {
    Throw "PowerShell version 7 or higher is required."
}
Clear-Host []

################################################
## intro and countdown
################################################

Write-Host -ForegroundColor Yellow "#######################################"
Write-Host -ForegroundColor Yellow "### Starke-DMS® unattended install ####"
Write-Host -ForegroundColor Yellow "#######################################"
Start-Sleep -s 2
Clear-Host []


################################################
## set language and rename computer to customerno
################################################

Set-WinUILanguageOverride -Language de-DE
Set-Culture de-DE
Set-WinUserLanguageList de-DE -Force
Start-Sleep -s 2
Clear-Host []


################################################
## Download section
################################################

Write-Host -ForegroundColor Green "##########################################"
Write-Host -ForegroundColor Green "######### downloading software ###########"
Write-Host -ForegroundColor Green "##########################################"

# download the license script
curl.exe "https://raw.githubusercontent.com/E-J-D/sdms-cloud1/main/Powershell/Install-Starke-DMS_license.ps1" --output C:\install\Install-Starke-DMS_license.ps1 --create-dirs

# download the DB fix script
curl.exe "https://raw.githubusercontent.com/E-J-D/sdms-cloud1/main/Powershell/Install-Starke-DMS_DBfixLic.ps1" --output C:\install\Install-Starke-DMS_DBfixLic.ps1 --create-dirs

# download predefined installer registry keys
curl.exe "https://raw.githubusercontent.com/E-J-D/sdms-cloud1/main/Powershell/Install-Starke-DMS_setup.reg" --output C:\install\StarkeDMS-latest\StarkeDMS-setup.reg --create-dirs
curl.exe "https://raw.githubusercontent.com/E-J-D/sdms-cloud1/main/Powershell/Install-ABBYY_setup.reg" --output C:\install\StarkeDMS-latest\ABBYY-setup.reg --create-dirs

# download the Office installer
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/SW_DVD5_Office_2016_64Bit_German_MLF_X20-42484.ISO" --ssl-reqd -k --output C:\install\StarkeDMS-latest\SW_DVD5_Office_2016_64Bit_German_MLF_X20-42484.ISO --create-dirs
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/SW_DVD5_Office_2016_64Bit_German_MLF_X20-42484_template.MSP" --ssl-reqd -k --output C:\install\StarkeDMS-latest\SW_DVD5_Office_2016_64Bit_German_MLF_X20-42484_template.MSP --create-dirs
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/SW_DVD5_Office_2016_64Bit_German_MLF_X20-42484_template.xml" --ssl-reqd -k --output C:\install\StarkeDMS-latest\SW_DVD5_Office_2016_64Bit_German_MLF_X20-42484_template.xml --create-dirs


# download the MC installer
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/mcwin32-build226-setup.exe" --ssl-reqd -k --output C:\install\StarkeDMS-latest\mcwin32-build226-setup.exe --create-dirs

# download the latest Starke-DMS® installer
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/StarkeDMSlatest.zip" --ssl-reqd -k --output C:\install\StarkeDMS-latest\StarkeDMSlatest.zip --create-dirs

# download the latest sql express installer
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/SQLEXPRADV_x64_DEU.exe" --ssl-reqd -k --output C:\install\StarkeDMS-latest\SQLEXPRADV_x64_DEU.exe --create-dirs

# download the latest sql express ini
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/SQLEXPRADV_x64_DEU.ini" --ssl-reqd -k --output C:\install\StarkeDMS-latest\SQLEXPRADV_x64_DEU.ini --create-dirs

# download the latest ssms installer
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/SSMS-Setup-ENU.exe" --ssl-reqd -k --output C:\install\StarkeDMS-latest\SSMS-Setup-ENU.exe --create-dirs

# download the latest ABBYY installer
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/ABBYYlatest.zip" --ssl-reqd -k --output C:\install\StarkeDMS-latest\ABBYYlatest.zip --create-dirs

# download the terra backup installer
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/Agent-Windows-x64-9-21-1018.exe" --ssl-reqd -k --output C:\install\StarkeDMS-latest\Agent-Windows-x64-9-21-1018.exe --create-dirs

# download the MSOLE DB driver
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/msoledbsql_18.6.3_x64.msi" --ssl-reqd -k --output C:\install\StarkeDMS-latest\msoledbsql_18.6.3_x64.msi --create-dirs

# download the MS ODBC SQL DB driver
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/msodbcsql17.msi" --ssl-reqd -k --output C:\install\StarkeDMS-latest\msodbcsql17.msi --create-dirs

# download the MsSqlCmdLnUtils sqlcmd.exe
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/MsSqlCmdLnUtils.msi" --ssl-reqd -k --output C:\install\StarkeDMS-latest\MsSqlCmdLnUtils.msi --create-dirs

# download the Microsoft Visual C++ 2015-2019 Redistributable (x64, x86)
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/VC_redist.x64.exe" --ssl-reqd -k --output C:\install\StarkeDMS-latest\VC_redist.x64.exe --create-dirs
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/VC_redist.x86.exe" --ssl-reqd -k --output C:\install\StarkeDMS-latest\VC_redist.x86.exe --create-dirs

# download the WebApache ZIP
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/WebApache.zip" --ssl-reqd -k --output C:\install\StarkeDMS-latest\WebApache.zip --create-dirs



# download the Template DB
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/SQL-DB-CLOUD1MASTER1.bak" --ssl-reqd -k --output C:\install\StarkeDMS-latest\SQL-DB-CLOUD1MASTER1.bak --create-dirs

Write-Host -ForegroundColor Green "##########################################"
Write-Host -ForegroundColor Green "######### software downloaded ############"
Write-Host -ForegroundColor Green "##########################################"
Start-Sleep -s 2
Clear-Host []


################################################
## unzip 
################################################

Write-Host -ForegroundColor Green "##########################################"
Write-Host -ForegroundColor Green "########## unzipping software ############"
Write-Host -ForegroundColor Green "##########################################"

# expand the Starke-DMS ZIP
Expand-Archive -LiteralPath C:\install\StarkeDMS-latest\StarkeDMSlatest.zip -DestinationPath C:\install\StarkeDMS-latest

# expand the sql express setup
Start-Process -wait C:\install\StarkeDMS-latest\SQLEXPRADV_x64_DEU.exe -ArgumentList "/q /x:C:\install\StarkeDMS-latest\SQL"

# expand the ABBYY ZIP
Expand-Archive -LiteralPath C:\install\StarkeDMS-latest\ABBYYlatest.zip -DestinationPath C:\install\StarkeDMS-latest

# expand the WebApache ZIP
Expand-Archive -LiteralPath C:\install\StarkeDMS-latest\WebApache.zip -DestinationPath d:\tools


# delete the downloaded ZIPs
Remove-Item C:\install\StarkeDMS-latest\StarkeDMSlatest.zip
Remove-Item C:\install\StarkeDMS-latest\ABBYYlatest.zip
Remove-Item C:\install\StarkeDMS-latest\WebApache.zip

# rename the downloaded installer to *latest
Get-ChildItem -Path C:\install\StarkeDMS-latest\* -Include StarkeDMS*.exe | Rename-Item -NewName StarkeDMS-latest.exe
Get-ChildItem -Path C:\install\StarkeDMS-latest\* -Include ABBYY*.exe | Rename-Item -NewName ABBYY-latest.exe

Write-Host -ForegroundColor Green "##########################################"
Write-Host -ForegroundColor Green "########### software unzipped ############"
Write-Host -ForegroundColor Green "##########################################"
Start-Sleep -s 2
Clear-Host []


################################################
## import predefined registry keys
################################################

Write-Host -ForegroundColor Green "##########################################"
Write-Host -ForegroundColor Green "########## importing reg keys ############"
Write-Host -ForegroundColor Green "##########################################"

reg import C:\install\StarkeDMS-latest\StarkeDMS-setup.reg /reg:64
reg import C:\install\StarkeDMS-latest\ABBYY-setup.reg /reg:64

Write-Host -ForegroundColor Green "##########################################"
Write-Host -ForegroundColor Green "########### reg keys imported ############"
Write-Host -ForegroundColor Green "##########################################"
Start-Sleep -s 2
Clear-Host []

################################################
## install all the stuff
################################################


# run the Microsoft Visual C++ 2015-2019 Redistributable (x64, x86) installer in silent mode
Write-Host -ForegroundColor Green "###################################################"
Write-Host -ForegroundColor Green "# installing Microsoft Visual C++ Redistributable #"
Write-Host -ForegroundColor Green "###################################################"
Start-Process -Wait -FilePath 'C:\install\StarkeDMS-latest\VC_redist.x64.exe' -ArgumentList "/install /quiet /norestart"
Start-Sleep -s 2
Start-Process -Wait -FilePath 'C:\install\StarkeDMS-latest\VC_redist.x86.exe' -ArgumentList "/install /quiet /norestart"
Write-Host -ForegroundColor Yellow "#############################################"
Write-Host -ForegroundColor Green  "#### Microsoft Visual C++ Redistributable ###"
Write-Host -ForegroundColor Yellow "#############################################"
Write-Host 
Write-Host  
Start-Sleep -s 2
Clear-Host []

# run the MC installer in silent mode
Write-Host -ForegroundColor Green "##########################################"
Write-Host -ForegroundColor Green "# installing MC #"
Write-Host -ForegroundColor Green "##########################################"
Start-Process -Wait -FilePath 'C:\install\StarkeDMS-latest\mcwin32-build226-setup.exe' -ArgumentList "/VERYSILENT /NORESTART"
Write-Host -ForegroundColor Yellow "#########################################"
Write-Host -ForegroundColor Green  "############ MC installed ###############"
Write-Host -ForegroundColor Yellow "#########################################"
Write-Host 
Write-Host  
Start-Sleep -s 2
Clear-Host []

# run the Starke-DMS installer in silent mode and wait 3sec
Write-Host -ForegroundColor Green "##########################################"
Write-Host -ForegroundColor Green "# installing Starke-DMS #"
Write-Host -ForegroundColor Green "##########################################"
Start-Process -Wait -FilePath 'C:\install\StarkeDMS-latest\StarkeDMS-latest.exe' -ArgumentList /S -PassThru
Start-Sleep -s 3
Write-Host -ForegroundColor Yellow "################################################"
Write-Host -ForegroundColor Green  "########### Starke-DMS® installed ##############"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host 
Write-Host  
Start-Sleep -s 2
Clear-Host []

# run the ABBYY installer in silent mode and wait 3sec
Write-Host -ForegroundColor Green "##########################################"
Write-Host -ForegroundColor Green "# installing Abbyy engine #"
Write-Host -ForegroundColor Green "##########################################"
Start-Process -Wait -FilePath 'C:\install\StarkeDMS-latest\ABBYY-latest.exe' -ArgumentList /S -PassThru
Start-Sleep -s 3
Write-Host -ForegroundColor Yellow "################################################"
Write-Host -ForegroundColor Green  "######### ABBYY engine installed ###############"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host 
Write-Host  
Start-Sleep -s 2
Clear-Host []



# run the terra backup agent installer in silent mode and wait 3sec
# https://wiki.terracloud.de/index.php/Backup#Installation_.C3.BCber_das_Setup
# 15.11.2022 Eike Doose: silent installer does not work. Agent has to be installed manually.
#Write-Host -ForegroundColor Green "#################################"
#Write-Host -ForegroundColor Green "# installing terra backup agent #"
#Write-Host -ForegroundColor Green "#################################"
#Start-Process -Wait -FilePath 'C:\install\StarkeDMS-latest\Agent-Windows-x64-9-21-1018.exe' -ArgumentList "/s /v ""REGISTERWITHWEBCC=True AMPNWADDRESS=backup.terracloud.de AMPUSERNAME=backupkunde@firmaXYZ.de AMPPASSWORD=password FEATUREVOLUMEIMAGE=ON /qn"""
#Start-Sleep -s 3
#Write-Host -ForegroundColor Yellow "################################################"
#Write-Host -ForegroundColor Green  "####### terra backup agent installed ###########"
#Write-Host -ForegroundColor Yellow "################################################"
#Write-Host 
#Write-Host
#Start-Sleep -s 2
#Clear-Host []



# run the sql express installer in silent mode and wait 3sec
Write-Host -ForegroundColor Green "##########################################"
Write-Host -ForegroundColor Green "# installing SQL DB engine #"
Write-Host -ForegroundColor Green "##########################################"
Start-Process -Wait -FilePath 'C:\install\StarkeDMS-latest\SQL\setup.exe' -ArgumentList "/ConfigurationFile=C:\install\StarkeDMS-latest\SQLEXPRADV_x64_DEU.ini /SAPWD=$saPass"
Start-Sleep -s 3
Write-Host -ForegroundColor Yellow "################################################"
Write-Host -ForegroundColor Green  "######### SQL DB engine installed ##############"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host 
Write-Host
Start-Sleep -s 2
Clear-Host []

# install sql powershell util
Write-Host -ForegroundColor Green "##########################################"
Write-Host -ForegroundColor Green "# installing sqlserver powershell tools #"
Write-Host -ForegroundColor Green "##########################################"
Install-Module -Name NuGet -force
#Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name SqlServer -force
Write-Host -ForegroundColor Yellow "################################################"
Write-Host -ForegroundColor Green  "##### SqlServer PowerShell utils installed #####"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host 
Write-Host
Start-Sleep -s 2
Clear-Host []

# install MSOLE DB driver
# not necessary if sql express is already installed 
#Start-Process -wait C:\install\StarkeDMS-latest\msoledbsql_18.6.3_x64.msi -ArgumentList "IACCEPTMSOLEDBSQLLICENSETERMS=YES /qn"
#Write-Host -ForegroundColor Yellow "################################################"
#Write-Host -ForegroundColor Green  "########### MSOLEDBSQL installed ###############"
#Write-Host -ForegroundColor Yellow "################################################"
#Write-Host 
#Write-Host  

# install MS ODBC SQL17 driver
# not necessary if sql express is already installed
#Start-Process -wait C:\install\StarkeDMS-latest\msodbcsql17.msi -ArgumentList "IACCEPTMSODBCSQLLICENSETERMS=YES /qn"
#Write-Host -ForegroundColor Yellow "################################################"
#Write-Host -ForegroundColor Green  "########### MSODBCSQL18 installed ##############"
#Write-Host -ForegroundColor Yellow "################################################"
#Write-Host 
#Write-Host  

# install SSMS
Write-Host -ForegroundColor Green "##########################################"
Write-Host -ForegroundColor Green "# installing SSMS #"
Write-Host -ForegroundColor Green "##########################################"
Start-Process -Wait -FilePath c:\install\StarkeDMS-latest\SSMS-Setup-ENU.exe -ArgumentList "/install /quiet /norestart"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host -ForegroundColor Green  "############## SSMS installed ##################"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host 
Write-Host  
Start-Sleep -s 2
Clear-Host []

# install MS SQL Utils (SQLCMD.exe) toolset
# ???? not necessary if ssms is already installed
Write-Host -ForegroundColor Green "##########################################"
Write-Host -ForegroundColor Green "# MS SQL cli utils #"
Write-Host -ForegroundColor Green "##########################################"
Start-Process -wait C:\install\StarkeDMS-latest\MsSqlCmdLnUtils.msi -ArgumentList "IACCEPTMSSQLCMDLNUTILSLICENSETERMS=YES /qn"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host -ForegroundColor Green  "####### MS SQL cli utils installed #############"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host 
Write-Host  
Start-Sleep -s 2
Clear-Host []

# message when everything is done
Write-Host -ForegroundColor Yellow "################################################"
Write-Host -ForegroundColor Green  "############  Installation done  ###############"
Write-Host -ForegroundColor Green  "###  Thank you for using www.Starke-DMS.com  ###"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host 
Write-Host  

# message continue to customer config
#Write-Host -ForegroundColor Yellow "################################################"
#Write-Host -ForegroundColor Green  "###############  press any key #################"
#Write-Host -ForegroundColor Green  "###  to continue with customer config, lic++ ###"
#Write-Host -ForegroundColor Yellow "################################################"
#Write-Host 
#Write-Host  
# press any key to continue
Start-Sleep -s 2
Clear-Host []


## /////////////////////////////////////////////
## install Microsoft Office
## /////////////////////////////////////////////

## ISO mount
## /////////////////////////////////////////////

Write-Host -ForegroundColor Green "##########################################"
Write-Host -ForegroundColor Green "########## mounting office ISO ###########"
Write-Host -ForegroundColor Green "##########################################"

Mount-DiskImage -ImagePath "C:\install\StarkeDMS-latest\SW_DVD5_Office_2016_64Bit_German_MLF_X20-42484.ISO"

Write-Host -ForegroundColor yellow "##########################################"
Write-Host -ForegroundColor green  "############### ISO mounted ##############"
Write-Host -ForegroundColor yellow "##########################################"
Start-Sleep -s 2
# Clear-Host []

# run the Office installer in silent mode
Write-Host -ForegroundColor Green "###################################################"
Write-Host -ForegroundColor Green "# installing Microsoft Office 2016 (S+R Settings) #"
Write-Host -ForegroundColor Green "###################################################"

Start-Process -Wait -FilePath 'f:\setup.exe' -ArgumentList "/adminfile C:\install\StarkeDMS-latest\SW_DVD5_Office_2016_64Bit_German_MLF_X20-42484_template.msp"

Write-Host -ForegroundColor Yellow "################################################"
Write-Host -ForegroundColor Green  "##### Microsoft Office 2016 S+R  installed #####"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host 
Write-Host  
Start-Sleep -s 2
# Clear-Host []

## ISO unmount
## /////////////////////////////////////////////

Write-Host -ForegroundColor Green "##########################################"
Write-Host -ForegroundColor Green "######## unmounting office ISO ###########"
Write-Host -ForegroundColor Green "##########################################"

DisMount-DiskImage -ImagePath "C:\install\StarkeDMS-latest\SW_DVD5_Office_2016_64Bit_German_MLF_X20-42484.ISO"

Write-Host -ForegroundColor yellow "##########################################"
Write-Host -ForegroundColor Green  "######## office ISO unmounted  ###########"
Write-Host -ForegroundColor yellow "##########################################"
Write-Host 
Write-Host 
Start-Sleep -s 2
# Clear-Host []


## activate with terra cloud VL
## /////////////////////////////////////////////

Write-Host -ForegroundColor Green "##########################################"
Write-Host -ForegroundColor Green "######## volume licensing ################"
Write-Host -ForegroundColor Green "##########################################"

# slmgr.vbs /skms 185.35.12.116:1688
# cd "C:\Program Files\Microsoft Office\Office16\"
# cscript ospp.vbs /act

Start-Process -Wait -FilePath 'slmgr' -ArgumentList "//b /skms 185.35.12.116:1688"
Start-Sleep -s 2
start-process "cscript.exe" -Argumentlist '"C:\Program Files\Microsoft Office\Office16\ospp.vbs" /act' -wait

Write-Host -ForegroundColor yellow "####################################"
Write-Host -ForegroundColor Green  "######## office licensed ###########"
Write-Host -ForegroundColor yellow "####################################"
Start-Sleep -s 2
Clear-Host []




################################################
## Starke-DMS license download
################################################

# message continue to customer config
Write-Host -ForegroundColor Green "##########################################"
Write-Host -ForegroundColor Green "# downloading Stark-DMS license #"
Write-Host -ForegroundColor Green "##########################################"
# press any key to continue
#[Console]::ReadKey()

# Start-Process -wait "C:\Program Files\PowerShell\7\pwsh.exe" -ArgumentList "c:\install\Install-Starke-DMS_license.ps1 -username $LIZuser -password $LIZpass -server https://starke-dms-license.azurewebsites.net -uid $LIZuid -targetdir $LIZtargetdir" 
c:\install\Install-Starke-DMS_license.ps1 -username $LIZuser -password $LIZpass -server https://starke-dms-license.azurewebsites.net -uid $LIZuid -targetdir $LIZtargetdir

Write-Host -ForegroundColor Yellow "################################################"
Write-Host -ForegroundColor Green  "# Starke-DMS license downloaded #"
Write-Host -ForegroundColor Yellow "################################################"
Start-Sleep -s 2
Clear-Host []



################################################
## Starke-DMS SQL DB config
################################################

Write-Host -ForegroundColor Yellow "#####################################"
Write-Host -ForegroundColor Yellow "# initial DB will be created #"
Write-Host -ForegroundColor Yellow "#####################################"

# press ENTER to continue
#[Console]::ReadKey()


# create DMSServer.ini
'[DB]','ConnectionString=Provider=MSOLEDBSQL;SERVER=localhost\SDMSCLOUD1;DATABASE=CLOUD1MASTER1','[Network]','Port=27244','[Lizenz]','File=APLizenz.liz' | out-file d:\dms-config\DMSServer.ini

# create initial DB
Start-Process -wait -filepath "C:\Program Files (x86)\StarkeDMS\win64\DMSServer.exe"  -ArgumentList "-AdminPwd $saPass -cli -dbupdate -configpath $LIZtargetdir"

Write-Host -ForegroundColor Yellow "################################################"
Write-Host -ForegroundColor Green  "# initial DB created #"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host 
Write-Host  
Start-Sleep -s 2
Clear-Host []


Write-Host -ForegroundColor Yellow "#####################################"
Write-Host -ForegroundColor Yellow "# template DB will be restored #"
Write-Host -ForegroundColor Yellow "#####################################"
Write-Host
Write-Host

# press ENTER to continue
#[Console]::ReadKey()
# CLOUD1MASTER1 restore

cd "D:\dms-data\sql\Client SDK\ODBC\170\Tools\Binn\"
.\sqlcmd -S localhost\SDMSCLOUD1 -U SA -P $saPass -Q "RESTORE DATABASE [CLOUD1MASTER1] FROM  DISK = N'C:\install\StarkeDMS-latest\SQL-DB-CLOUD1MASTER1.bak' WITH  FILE = 1,  MOVE N'CLOUD1MASTER1_Pri' TO N'D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\CLOUD1MASTER1_Pri.mdf',  MOVE N'CLOUD1MASTER1_Dat' TO N'D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\CLOUD1MASTER1_Dat.ndf',  MOVE N'CLOUD1MASTER1_txt' TO N'D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\CLOUD1MASTER1_Txt.ndf',  MOVE N'CLOUD1MASTER1_Log' TO N'D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\CLOUD1MASTER1_Log.ldf',  NOUNLOAD,  REPLACE,  STATS = 5;"

# rename DB to DB$customerno
.\sqlcmd -S localhost\SDMSCLOUD1 -U SA -P $saPass -Q "ALTER DATABASE CLOUD1MASTER1 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;"
.\sqlcmd -S localhost\SDMSCLOUD1 -U SA -P $saPass -Q "ALTER DATABASE CLOUD1MASTER1 MODIFY FILE (NAME=N'CLOUD1MASTER1_Pri', NEWNAME=N'$customerno-pri');"
.\sqlcmd -S localhost\SDMSCLOUD1 -U SA -P $saPass -Q "ALTER DATABASE CLOUD1MASTER1 MODIFY FILE (NAME=N'CLOUD1MASTER1_Log', NEWNAME=N'$customerno-log');"
.\sqlcmd -S localhost\SDMSCLOUD1 -U SA -P $saPass -Q "ALTER DATABASE CLOUD1MASTER1 MODIFY FILE (NAME=N'CLOUD1MASTER1_Dat', NEWNAME=N'$customerno-dat');"
.\sqlcmd -S localhost\SDMSCLOUD1 -U SA -P $saPass -Q "ALTER DATABASE CLOUD1MASTER1 MODIFY FILE (NAME=N'CLOUD1MASTER1_Txt', NEWNAME=N'$customerno-txt');"
.\sqlcmd -S localhost\SDMSCLOUD1 -U SA -P $saPass -Q "ALTER DATABASE CLOUD1MASTER1 MODIFY FILEGROUP [CLOUD1MASTER1_Dat] NAME = [$customerno-dat]"
.\sqlcmd -S localhost\SDMSCLOUD1 -U SA -P $saPass -Q "ALTER DATABASE CLOUD1MASTER1 MODIFY FILEGROUP [CLOUD1MASTER1_txt] NAME = [$customerno-txt]"
.\sqlcmd -S localhost\SDMSCLOUD1 -U SA -P $saPass -Q "EXEC master.dbo.sp_detach_db @dbname = N'CLOUD1MASTER1'"


# rename DB files 
Get-ChildItem D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\CLOUD1MASTER1* | Rename-Item -NewName { $_.Name -replace '_','-' }
Get-ChildItem D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\CLOUD1MASTER1* | Rename-Item -NewName { $_.Name -replace 'CLOUD1MASTER1',$customerno }

# create renamed DB
.\sqlcmd -S localhost\SDMSCLOUD1 -U SA -P $saPass -Q "CREATE DATABASE CLOUD1MASTER1 ON ( FILENAME = N'D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\$customerno-pri.mdf' ), ( FILENAME = N'D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\$customerno-log.ldf' ), ( FILENAME = N'D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\$customerno-dat.ndf' ), ( FILENAME = N'D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\$customerno-txt.ndf' ) FOR ATTACH;"
.\sqlcmd -S localhost\SDMSCLOUD1 -U SA -P $saPass -Q "ALTER DATABASE CLOUD1MASTER1 SET MULTI_USER;"
.\sqlcmd -S localhost\SDMSCLOUD1 -U SA -P $saPass -Q "ALTER DATABASE CLOUD1MASTER1 MODIFY NAME = [$customerno];"

# change DB in DMSServer.ini to new DB name
'[DB]',"ConnectionString=Provider=MSOLEDBSQL;SERVER=localhost\SDMSCLOUD1;DATABASE=$customerno",'[Network]','Port=27244','[Lizenz]','File=APLizenz.liz' | out-file d:\dms-config\DMSServer.ini

# fix DB to new customer
cd "D:\dms-data\sql\Client SDK\ODBC\170\Tools\Binn\"
C:\install\Install-Starke-DMS_DBfixLic.ps1 -sqlserver localhost\SDMSCLOUD1 -database $customerno -username 'sa' -password $saPass -configpath $LIZtargetdir

# update system DB user
.\sqlcmd -S localhost\SDMSCLOUD1 -U SA -d $customerno -P $saPass -Q "ALTER USER ArchivPlus WITH LOGIN = ArchivPlus;"

# check and upgrade DB if necessary
Start-Process -wait -filepath "C:\Program Files (x86)\StarkeDMS\win64\DMSServer.exe"  -ArgumentList "-AdminPwd $saPass -cli -dbupdate -configpath $LIZtargetdir"

Write-Host -ForegroundColor Yellow "################################################"
Write-Host -ForegroundColor Green  "# template DB restored #"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host 
Write-Host  
Start-Sleep -s 2
Clear-Host []
Start-Sleep -s 2
Clear-Host []


################################################
## Starke-DMS services config
## https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/new-service?view=powershell-7.2
################################################

#####################################################################################
#####################################################################################
# DMS Server service install and start
# ------------------------------------
Write-Host -ForegroundColor Yellow "####################################"
Write-Host -ForegroundColor Yellow "DMS Server Service will be installed"
Write-Host -ForegroundColor Yellow "####################################"
Write-Host
#Write-Host -ForegroundColor Yellow "#########  press any key  ##########"

# press any key to continue
#[Console]::ReadKey()

$params = @{
  Name = "DMS_01_Server"
  BinaryPathName = 'C:\Program Files (x86)\StarkeDMS\win64\DMSServerSvc.exe /name "DMS_01_Server" /ini DMSServer.ini /configpath "d:\dms-config"'
  StartupType = "AutomaticDelayedStart"
  Description = "Starke-DMS Server"
}
New-Service @params

Start-Sleep -s 1
Start-Service -Name "DMS_01_Server"
Start-Sleep -s 3

Write-Host -ForegroundColor Yellow "################################################"
Write-Host -ForegroundColor Green  "# DMS server service installed #"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host 
Write-Host  
Start-Sleep -s 2
Clear-Host []

#####################################################################################
#####################################################################################
# DMS LicenseManager service install and start
# --------------------------------------------
Write-Host -ForegroundColor Yellow "############################################"
Write-Host -ForegroundColor Yellow "DMS LicenseManager service will be installed"
Write-Host -ForegroundColor Yellow "############################################"
Write-Host
#Write-Host -ForegroundColor Yellow "#############  press any key  ##############"

# press any key to continue
#[Console]::ReadKey()

#'[DB]','ConnectionString=Provider=MSOLEDBSQL;SERVER=localhost\SDMSCLOUD1;DATABASE=$customerno,'[Network]','Port=27244','[Lizenz]','File=APLizenz.liz' | out-file d:\dms-config\DMSLicenseManager.ini
'[Service]','User=system','Password=system','Server=localhost','Port=27244' | out-file d:\dms-config\DMSLicenseManager.ini

$params = @{
  Name = "DMS_02_LicenseManager"
  BinaryPathName = 'C:\Program Files (x86)\StarkeDMS\win64\DMSLizenzmanagerSvc.exe /name "DMS_02_LicenseManager" /Ini "DMSLicenseManager.ini" /ConfigPath "D:\dms-config"'
  StartupType = "AutomaticDelayedStart"
  Description = "Starke-DMS License Manager"
  DependsOn = "DMS_01_Server"
}
New-Service @params

Start-Sleep -s 1
Start-Service -Name "DMS_02_LicenseManager"
Start-Sleep -s 3

Write-Host -ForegroundColor Yellow "################################################"
Write-Host -ForegroundColor Green  "# DMS LicenseManager service installed #"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host 
Write-Host  
Start-Sleep -s 2
Clear-Host []


#####################################################################################
#####################################################################################
#DMS FileExport service install and start
#----------------------------------

Write-Host -ForegroundColor Yellow "############################################"
Write-Host -ForegroundColor Yellow "DMS FileExport service will be installed"
Write-Host -ForegroundColor Yellow "############################################"
Write-Host

######################################
# tbd - FileExport.ini der get--IT2022
#[Service]
#Server=localhost
#Port=27244
#User=import
#Password=
#Debug=0

#PasswordAES=1:x40abI48LkuhGownfvQOdw==
#[AR-Export]
#Active=1
#OutFile=C:\Temp\Export\%idx:0%.csv
#DocFile=C:\Temp\Export\%idx:0%
#DecimalSeparator=,
#ThousandSeparator=.
#WaitForJob=
#OutFileEncoding=

#[AR-Export.Search]
#100:=:Eingangs-Rechnung
#10000:=:Xony AG

#[AR-Export.Header]
#Interne Belegnummer;Lieferantenname;Lieferantennummer;Belegnummer;Belegdatum;Bestellnummer;FiBu-Status;Gesamtsumme netto;MwSt;Gesamtsumme brutto
#[AR-Export.Body]
#%idx:70%;%idx:10000%;%idx:10001%;%idx:10002%;%idx:10015%;%idx:10004%;%idx:10011%;%idx:10008%;%idx:10009%;%idx:10010%
#[AR-Export.Footer]
#[AR-Export.Update]
######################################

## Write-Host -ForegroundColor Yellow "######### press ENTER to continue ##########"

## press ENTER to continue
##[Console]::ReadKey()

######################################
#'[Service]','User=system','Password=system','Server=localhost','Port=27244' | out-file d:\dms-config\DMSfileExport.ini

#$params = @{
#  Name = "DMS_03_FileExport"
#  BinaryPathName = 'C:\Program Files (x86)\StarkeDMS\win64\DMSFileExportSvc.exe /name "DMS_03_FileExport" /Ini "DMSfileExport.ini" /ConfigPath "D:\dms-config"'
#  StartupType = "AutomaticDelayedStart"
#  Description = "Starke-DMS FileExport"
#  DependsOn = "DMS_01_Server"
#}
#New-Service @params

#Start-Sleep -s 1
#Start-Service -Name "DMS_03_FileExport"
#Start-Sleep -s 3

#Write-Host -ForegroundColor Yellow "################################################"
#Write-Host -ForegroundColor Green  "# DMS FileExport service installed #"
#Write-Host -ForegroundColor Yellow "################################################"
#Write-Host 
#Write-Host  
#Start-Sleep -s 2
#Clear-Host []


#####################################################################################
#####################################################################################
# DMS FileImport service install and start - 04
# ----------------------------------

#Write-Host -ForegroundColor Yellow "############################################"
#Write-Host -ForegroundColor Yellow "DMS FileImport service will be installed"
#Write-Host -ForegroundColor Yellow "############################################"
#Write-Host
#Write-Host -ForegroundColor Yellow "######### press ENTER to continue ##########"

# press ENTER to continue
#[Console]::ReadKey()


#####################################################################################
#####################################################################################
# DMS IndexAgent service install and start - 05
# ----------------------------------

#Write-Host -ForegroundColor Yellow "############################################"
#Write-Host -ForegroundColor Yellow "DMS IndexAgent service will be installed"
#Write-Host -ForegroundColor Yellow "############################################"
#Write-Host
#Write-Host -ForegroundColor Yellow "######### press ENTER to continue ##########"

# press ENTER to continue
#[Console]::ReadKey()


#####################################################################################
#####################################################################################
# DMS LookupImport service install and start - 06
# ----------------------------------

#Write-Host -ForegroundColor Yellow "############################################"
#Write-Host -ForegroundColor Yellow "DMS LookupImport service will be installed"
#Write-Host -ForegroundColor Yellow "############################################"
#Write-Host
#Write-Host -ForegroundColor Yellow "######### press ENTER to continue ##########"

# press ENTER to continue
#[Console]::ReadKey()


#####################################################################################
#####################################################################################
# DMS MailImport service install and start - 07
# ----------------------------------

#Write-Host -ForegroundColor Yellow "############################################"
#Write-Host -ForegroundColor Yellow "DMS MailImport service will be installed"
#Write-Host -ForegroundColor Yellow "############################################"
#Write-Host
#Write-Host -ForegroundColor Yellow "######### press ENTER to continue ##########"

# press ENTER to continue
#[Console]::ReadKey()


#####################################################################################
#####################################################################################
# DMS PDFConv service install and start - 08
# ----------------------------------

#Write-Host -ForegroundColor Yellow "############################################"
#Write-Host -ForegroundColor Yellow "DMS PDFConv service will be installed"
#Write-Host -ForegroundColor Yellow "############################################"
#Write-Host
#Write-Host -ForegroundColor Yellow "######### press ENTER to continue ##########"

# press ENTER to continue
#[Console]::ReadKey()


#####################################################################################
#####################################################################################
# DMS ServerOCR service install and start - 09
# ----------------------------------

#Write-Host -ForegroundColor Yellow "############################################"
#Write-Host -ForegroundColor Yellow "DMS ServerOCR service will be installed"
#Write-Host -ForegroundColor Yellow "############################################"
#Write-Host
#Write-Host -ForegroundColor Yellow "######### press ENTER to continue ##########"

# press ENTER to continue
#[Console]::ReadKey()


#####################################################################################
#####################################################################################
# DMS ServerRecognition service install and start - 10
# ----------------------------------

#Write-Host -ForegroundColor Yellow "############################################"
#Write-Host -ForegroundColor Yellow "DMS ServerRecognition service will be installed"
#Write-Host -ForegroundColor Yellow "############################################"
#Write-Host
#Write-Host -ForegroundColor Yellow "######### press ENTER to continue ##########"

# press ENTER to continue
#[Console]::ReadKey()


#####################################################################################
#####################################################################################
# DMS WebApache service install and start - 11
# ----------------------------------

Write-Host -ForegroundColor Yellow "############################################"
Write-Host -ForegroundColor Yellow "DMS WebApache service will be installed"
Write-Host -ForegroundColor Yellow "############################################"
Write-Host

'[DMSServer]','Server=localhost','Port=27244','[SSL]','Use=False' | out-file d:\dms-config\DMSWebServer.ini

Start-Process -Wait -FilePath 'd:\Tools\Apache24\bin\httpd.exe' -ArgumentList '-k install -n "DMS_11_WebApache" -f "d:\Tools\Apache24\conf\httpd.conf"'

Start-Sleep -s 1
Start-Service -Name "DMS_11_WebApache"
Start-Sleep -s 3

Write-Host -ForegroundColor Yellow "################################################"
Write-Host -ForegroundColor Green  "# DMS WebApache service installed #"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host 
Write-Host  
Start-Sleep -s 2
Clear-Host []


#####################################################################################
#####################################################################################
# DMS xyz service install and start
# ----------------------------------

#Write-Host -ForegroundColor Yellow "############################################"
#Write-Host -ForegroundColor Yellow "DMS xyz  service will be installed"
#Write-Host -ForegroundColor Yellow "############################################"
#Write-Host
#Write-Host -ForegroundColor Yellow "######### press ENTER to continue ##########"

# press ENTER to continue
#[Console]::ReadKey()


################################################
## cleaning up
################################################

Write-Host -ForegroundColor Yellow "################################################"
Write-Host -ForegroundColor Green  "###############  press any key #################"
Write-Host -ForegroundColor Green  "###### to continue cleaning up everything ######"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host 
Write-Host  
#Write-Host -ForegroundColor Yellow "######### press ENTER to continue ##########"
# press ENTER to continue
#[Console]::ReadKey()

Start-Sleep -s 15

# delete DMS setup.exe 
Remove-Item "C:\Program Files (x86)\StarkeDMS\setup\setup.exe"
# Remove-Item C:\install\StarkeDMS-latest\ -Recurse -Force -Confirm:$false
Remove-Item C:\install\ -Recurse -Force -Confirm:$false
Clear-RecycleBin -Force
Start-Sleep -s 2
'[Info]','setup.exe was deleted after autoinstall' | out-file "C:\Program Files (x86)\StarkeDMS\setup\info.txt"
New-Item -Path "c:\" -Name "install" -ItemType "directory"
Start-Sleep -s 2
'[Info]','everything was deleted after autoinstall' | out-file "C:\install\info.txt"

# 15.11.2022 Eike Doose - download the terra backup agent due to need for manually install
# download the terra backup installer
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/Agent-Windows-x64-9-21-1018.exe" --ssl-reqd -k --output C:\install\Agent-Windows-x64-9-21-1018.exe --create-dirs

curl.exe "https://raw.githubusercontent.com/E-J-D/sdms-cloud1/main/Powershell/Install-Starke-DMS_03.ps1" --output c:\install\Install-Starke-DMS_03.ps1 --create-dirs



################################################
## restart computer
################################################
Write-Host -ForegroundColor Red "######################################################################"
Write-Host -ForegroundColor Red "## Computer will be restarted after 15s - press STRR-C to interrupt ##"
Write-Host -ForegroundColor Red "######################################################################"
Write-Host
#Write-Host -ForegroundColor Yellow "#############  press any key  ##############"
#[Console]::ReadKey()

Start-Sleep -s 15

Restart-computer -force
