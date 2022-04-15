# 14.04.2022 Eike Doose / licenced for commerical use only - do not distribute
# Install_01_only_powershell7 which is needed for following installation
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
#
# 08.04.2022 14:13 Starke-DMS® Cloud1 Master1-c
# .\Install-Starke-DMS_01.ps1 -FTPserver 'ftp.get--it.de' -FTPuser 'get--IT' -FTPpass 'get--IT2022' -customerno '50999'  

param (
	[string]$FTPserver = 'ftp.get--it.de',
	[Parameter(Mandatory=$true)][string]$FTPuser,
	[Parameter(Mandatory=$true)][string]$FTPpass,
	
	[Parameter(Mandatory=$true)][string]$customerno

)

# ============================================================================

cls

################################################
## intro 
################################################

Write-Host 
Write-Host  
Write-Host 
Write-Host -ForegroundColor Yellow "#######################################"
Write-Host -ForegroundColor Yellow "###### pwsh7 unattended install #######"
Write-Host -ForegroundColor Yellow "#######################################"
Write-Host
Write-Host
Write-Host

##################################################
## set language to de-DE
##################################################

Set-WinUILanguageOverride -Language de-DE
Set-Culture de-DE
Set-WinUserLanguageList de-DE -Force

################################################
## rename computer to $customerno
################################################

Rename-Computer -NewName SDMSC1-$customerno

################################################
## terracloud standard server with two hdd+dvd
## dvd is drive d: and second hdd is e: 
## must be second hdd d: and dvd e:
## change DVD drive temporaly letter to O:
################################################

Get-WmiObject -Class Win32_volume -Filter 'DriveType=5' |
  Select-Object -First 1 |
  Set-WmiInstance -Arguments @{DriveLetter='O:'}

$Drive = Get-CimInstance -ClassName Win32_Volume -Filter "DriveLetter = 'E:'"
$Drive | Set-CimInstance -Property @{DriveLetter ='D:'}

Get-WmiObject -Class Win32_volume -Filter 'DriveType=5' |
  Select-Object -First 1 |
  Set-WmiInstance -Arguments @{DriveLetter='E:'}

# label c: to "OS", d: to "data"
$Drive = Get-CimInstance -ClassName Win32_Volume -Filter "DriveLetter = 'C:'"
$Drive | Set-CimInstance -Property @{Label='OS'}
Get-CimInstance -ClassName Win32_Volume -Filter "DriveLetter = 'C:'" |
  Select-Object -Property SystemName, Label, DriveLetter

$Drive = Get-CimInstance -ClassName Win32_Volume -Filter "DriveLetter = 'D:'"
$Drive | Set-CimInstance -Property @{Label='DATA'}
Get-CimInstance -ClassName Win32_Volume -Filter "DriveLetter = 'D:'" |
  Select-Object -Property SystemName, Label, DriveLetter


Write-Host
Write-Host
Write-Host
Write-Host -ForegroundColor Green "#######################################"
Write-Host -ForegroundColor Green "###### default OS settings done #######"
Write-Host -ForegroundColor Green "#######################################"
Write-Host
Write-Host
Write-Host

################################################
## Download section
################################################

Write-Host
Write-Host
Write-Host
Write-Host -ForegroundColor Yellow "#######################################"
Write-Host -ForegroundColor Yellow "######### downloading pwsh7 ###########"
Write-Host -ForegroundColor Yellow "#######################################"
Write-Host
Write-Host
Write-Host

# download the PowerShell7 installer
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/PowerShell-7.2.2-win-x64.msi" --ssl-reqd -k --output C:\install\StarkeDMS-latest\PowerShell-7.2.2-win-x64.msi --create-dirs

Write-Host
Write-Host
Write-Host
Write-Host -ForegroundColor Green "#######################################"
Write-Host -ForegroundColor Green "######### download finished ###########"
Write-Host -ForegroundColor Green "#######################################"
Write-Host
Write-Host
Write-Host


################################################
## install all the stuff
################################################

# run the PowerShell7 installer in silent mode
Write-Host
Write-Host
Write-Host
Write-Host -ForegroundColor Yellow "##################################"
Write-Host -ForegroundColor Yellow "#### installing PowerShell 7 #####"
Write-Host -ForegroundColor Yellow "##################################"
Write-Host
Write-Host
Write-Host

Start-Process -wait -FilePath C:\install\StarkeDMS-latest\PowerShell-7.2.2-win-x64.msi -ArgumentList "/quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1 USE_MU=1 ENABLE_MU=1"

# create desktop shortcut for PowerShell 7 and run always as administrator
$objShell = New-Object -ComObject ("WScript.Shell")
$objShortCut = $objShell.CreateShortcut($env:USERPROFILE + "\Desktop" + "\PowerShell7.lnk")
$objShortCut.TargetPath="C:\Program Files\PowerShell\7\pwsh.exe"
$objShortCut.Save()

$bytes = [System.IO.File]::ReadAllBytes("$Home\Desktop\PowerShell7.lnk")
$bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 (0x15) bit 6 (0x20) ON
[System.IO.File]::WriteAllBytes("$Home\Desktop\PowerShell7.lnk", $bytes)

pause
  
################################################
## Powershell 7 Modul sqlserver install
## necessary for sqlcmd cmdlet
################################################

Import-Module sqlserver

pause
Write-Host
Write-Host
Write-Host
Write-Host -ForegroundColor Green "################################################"
Write-Host -ForegroundColor Green "######### PowerShell 7 installed ###############"
Write-Host -ForegroundColor Green "################################################"
Write-Host
Write-Host
Write-Host


################################################
## restart the computer
################################################
Restart-computer -force