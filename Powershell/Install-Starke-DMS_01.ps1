# 22.11.2022 Eike Doose / INTERNAL USER ONLY / do not distribute
# Install-Starke-DMS_01.ps1 install PowerShell 7 which is needed for following installation
# =========================================================================================
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

# Tests
# .\Install-Starke-DMS_01.ps1 -FTPserver 'ftp.get--it.de' -FTPuser 'get--IT' -FTPpass 'get--IT2022' -customerno '50999'  
# .\Install-Starke-DMS_01.ps1 -FTPserver 'ftp.get--it.de' -FTPuser 'get--IT' -FTPpass 'get--IT2022' -customerno '56999'  
# .\Install-Starke-DMS_01.ps1 -FTPserver 'ftp.get--it.de' -FTPuser 'get--IT' -FTPpass 'get--IT2022' -customerno '57999'  
# .\Install-Starke-DMS_01.ps1 -FTPserver '172.28.0.11' -FTPuser 'AUTOINSTALLER' -FTPpass 'wbutJzGFALFDrtmN' -customerno '57999'  

# VMware lokal test environment (22.11.2022)
# .\Install-Starke-DMS_01.ps1 -FTPserver '192.168.224.188' -FTPuser 'hausmeister' -FTPpass 'hausmeister' -customerno '36100'

param (
	[string]$FTPserver = 'ftp.get--it.de',
	[Parameter(Mandatory=$true)][string]$FTPuser,
	[Parameter(Mandatory=$true)][string]$FTPpass,
	[Parameter(Mandatory=$true)][string]$customerno

)

#######################################
## generate timestamp
#######################################

Function Get-Timestamp
{
$n=Get-Date
#pad values with leading 0 if necessary
$mo=(($n.Month).ToString()).PadLeft(2,"0")
$dy=(($n.Day).ToString()).PadLeft(2,"0")
$yr=($n.Year).ToString()
$hr=(($n.hour).ToString()).PadLeft(2,"0")
$mn=(($n.Minute).ToString()).PadLeft(2,"0")
$sec=(($n.Second).ToString()).PadLeft(2,"0")

$result=$yr+"-"+$mo+"-"+$dy+"_"+$hr+"-"+$mn+"-"+$sec

return $result
}
$t=Get-TimeStamp

#######################################
## generate password
#######################################
function Get-RandomCharacters($length, $characters) {
    $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
    $private:ofs=""
    return [String]$characters[$random]
}

function Scramble-String([string]$inputString){     
    $characterArray = $inputString.ToCharArray()   
    $scrambledStringArray = $characterArray | Get-Random -Count $characterArray.Length     
    $outputString = -join $scrambledStringArray
    return $outputString 
}

$password = Get-RandomCharacters -length 5 -characters 'abcdefghiklmnoprstuvwxyz'
$password += Get-RandomCharacters -length 5 -characters 'ABCDEFGHKLMNOPRSTUVWXYZ'
$password += Get-RandomCharacters -length 4 -characters '1234567890'
$password += Get-RandomCharacters -length 2 -characters '!"§$%&/()=?}][{@#*+'
$ftppassword = Scramble-String $password


#######################################
## Parameter for FTP server install
#######################################
$FTPsiteFull = "IIS:\Sites\SDMSC1-FTPSite01"
$FTPsiteShort = "SDMSC1-FTPSite01"
$FTPsitePath = "d:\dms-data\ftp-root\SDMSC1-FTPSite01"
$FTPuserName = "SDMSC1-FTP01-"+$customerno
$FTPUserPassword = ConvertTo-SecureString $ftppassword -AsPlainText -Force
$FTPgroup = "FTPGroup"
$FTProotFolderpath = "d:\dms-data\ftp-root"


## /////////////////////////////////////////////
## write new password and ftp username to file
## /////////////////////////////////////////////
'New FTP name and password',$t,'--------------------','new ftp user',$FTPuserName,'--------------------','new password',$ftppassword,'--------------------','--------------------','DELETE THIS FILE IMMEDIATELY','--------------------'  | out-file $env:USERPROFILE\Desktop\ftp_password_username.txt
Start-Sleep -s 1


################################################
## start logging 
################################################

Start-Transcript -Path "c:\install\_Log-Install-Starke-DMS_01-$t.txt" 

# ============================================================================

################################################
## stop script on PowerShell error 
################################################
$ErrorActionPreference = "Stop"

cls

################################################
## intro 
################################################

Write-Host 
Write-Host -ForegroundColor Yellow "#######################################"
Write-Host -ForegroundColor Yellow "# PowerShell 7 unattended install "
Write-Host -ForegroundColor Yellow "#######################################"
Write-Host
Write-Host 
Write-Host -ForegroundColor Yellow "#######################################"
Write-Host -ForegroundColor Yellow "# set default OS settings "
Write-Host -ForegroundColor Yellow "#######################################"
Write-Host

##################################################
## disable autostart for Windows server-manager
##################################################

Invoke-Command -ComputerName localhost -ScriptBlock { New-ItemProperty -Path HKCU:\Software\Microsoft\ServerManager -Name DoNotOpenServerManagerAtLogon -PropertyType DWORD -Value "0x1" –Force} 


##################################################
## basic explorer settings
##################################################

# Write-Host -Foreground Yellow "file extension on"
Set-ItemProperty -Type DWord -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -value "0"

# Write-Host -Foreground Yellow "menus always on"
Set-ItemProperty -Type DWord -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "AlwaysShowMenus" -value "1"

# Write-Host -Foreground Yellow "show status bar"
Set-ItemProperty -Type DWord -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowStatusBar" -value "1"

# Write-Host -Foreground Yellow "show full path"
# Set-ItemProperty -Type DWord -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" -Name "FullPath" -value "1"

# Write-Host -Foreground Yellow "show all folder"
Set-ItemProperty -Type DWord -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "NavPaneShowAllFolders" -value "1"

# Write-Host -Foreground Yellow "expand path"
Set-ItemProperty -Type DWord -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "NavPaneExpandToCurrentFolder" -value "1"


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
Write-Host -ForegroundColor Green "#######################################"
Write-Host -ForegroundColor Green "# default OS settings done "
Write-Host -ForegroundColor Green "#######################################"
Write-Host
Write-Host

################################################
## Download section
################################################

Write-Host
Write-Host 
Write-Host -ForegroundColor Yellow "#######################################"
Write-Host -ForegroundColor Yellow "# downloading PowerShell 7 "
Write-Host -ForegroundColor Yellow "#######################################"
Write-Host
Write-Host

# download the PowerShell7 installer
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/PowerShell-7.3.0-win-x64.msi" --ssl-reqd -k --output C:\install\StarkeDMS-latest\PowerShell-7.3.0-win-x64.msi --create-dirs

# download the Ansible config script
curl.exe "https://raw.githubusercontent.com/E-J-D/sdms-cloud1/main/Powershell/ConfigureRemotingForAnsible.ps1" --output C:\install\ConfigureRemotingForAnsible.ps1 --create-dirs

# download the Notepad++ installer
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/npp.8.4.7.Installer.x64.exe" --ssl-reqd -k --output C:\install\StarkeDMS-latest\npp.8.4.7.Installer.x64.exe --create-dirs


Write-Host
Write-Host
Write-Host -ForegroundColor Green "#######################################"
Write-Host -ForegroundColor Green "# download PowerShell 7 finished "
Write-Host -ForegroundColor Green "#######################################"
Write-Host
Write-Host



################################################
## install PowerShell 7
################################################

# run the PowerShell7 installer in silent mode
Write-Host
Write-Host 
Write-Host -ForegroundColor Yellow "#######################################"
Write-Host -ForegroundColor Yellow "# installing PowerShell 7 "
Write-Host -ForegroundColor Yellow "#######################################"
Write-Host
Write-Host

Start-Process -wait -FilePath C:\install\StarkeDMS-latest\PowerShell-7.3.0-win-x64.msi -ArgumentList "/quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1 USE_MU=1 ENABLE_MU=1"

# create desktop shortcut for PowerShell 7 and run always as administrator
$objShell = New-Object -ComObject ("WScript.Shell")
$objShortCut = $objShell.CreateShortcut($env:USERPROFILE + "\Desktop" + "\PowerShell7.lnk")
$objShortCut.TargetPath="C:\Program Files\PowerShell\7\pwsh.exe"
$objShortCut.Save()

$bytes = [System.IO.File]::ReadAllBytes("$Home\Desktop\PowerShell7.lnk")
$bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 (0x15) bit 6 (0x20) ON
[System.IO.File]::WriteAllBytes("$Home\Desktop\PowerShell7.lnk", $bytes)

$objShell = New-Object -ComObject ("WScript.Shell")
$objShortCut = $objShell.CreateShortcut($env:USERPROFILE + "\Desktop" + "\services.lnk")
$objShortCut.TargetPath="services.msc"
$objShortCut.Save()

$objShell = New-Object -ComObject ("WScript.Shell")
$objShortCut = $objShell.CreateShortcut($env:USERPROFILE + "\Desktop" + "\Install.lnk")
$objShortCut.TargetPath="C:\Windows\explorer.exe"
$objShortcut.Arguments = "c:\install"
$objShortCut.Save()

$objShell = New-Object -ComObject ("WScript.Shell")
$objShortCut = $objShell.CreateShortcut($env:USERPROFILE + "\Desktop" + "\DMS-config.lnk")
$objShortCut.TargetPath="C:\Windows\explorer.exe"
$objShortcut.Arguments = "d:\dms-config"
$objShortCut.Save()

$objShell = New-Object -ComObject ("WScript.Shell")
$objShortCut = $objShell.CreateShortcut($env:USERPROFILE + "\Desktop" + "\DMS-dir.lnk")
$objShortCut.TargetPath="C:\Windows\explorer.exe"
$objShortcut.Arguments = "C:\Program Files (x86)\StarkeDMS"
$objShortCut.Save()

$objShell = New-Object -ComObject ("WScript.Shell")
$objShortCut = $objShell.CreateShortcut($env:USERPROFILE + "\Desktop" + "\DMS-data.lnk")
$objShortCut.TargetPath="C:\Windows\explorer.exe"
$objShortcut.Arguments = "d:\dms-data"
$objShortCut.Save()


 
################################################
## Powershell 7 Modul sqlserver install
## necessary for sqlcmd cmdlet
################################################

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name SqlServer -force

Write-Host
Write-Host
Write-Host -ForegroundColor Green "#######################################"
Write-Host -ForegroundColor Green "# installing PowerShell 7 finished "
Write-Host -ForegroundColor Green "#######################################"
Write-Host
Write-Host


################################################
## Ansible config script
################################################

powershell.exe -File c:\install\ConfigureRemotingForAnsible.ps1
# iex(iwr https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1).Content

Write-Host
Write-Host
Write-Host -ForegroundColor Green "#######################################"
Write-Host -ForegroundColor Green "# Ansible config script finished "
Write-Host -ForegroundColor Green "#######################################"
Write-Host
Write-Host


################################################
## install Notepad++ in silent mode
################################################
Start-Process -Wait -FilePath 'C:\install\StarkeDMS-latest\npp.8.4.7.Installer.x64' -ArgumentList /S -PassThru
Write-Host
Write-Host
Write-Host -ForegroundColor Green "#######################################"
Write-Host -ForegroundColor Green "# Notepad++ installed "
Write-Host -ForegroundColor Green "#######################################"
Write-Host
Write-Host


################################################
## install Microsoft Edge in silent mode
################################################
#md -Path $env:temp\edgeinstall -erroraction SilentlyContinue | Out-Null
#$Download = join-path $env:temp\edgeinstall MicrosoftEdgeEnterpriseX64.msi
#Invoke-WebRequest 'https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/a2662b5b-97d0-4312-8946-598355851b3b/MicrosoftEdgeEnterpriseX64.msi'  -OutFile $Download
# Start-Process "$Download" -ArgumentList "/quiet"

# 10.11.2022 changed to download existing MSI package // https://msedge.sf.dl.... does not work anymore
# download the Microsoft Edge installer
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/MicrosoftEdgeEnterpriseX64.msi" --ssl-reqd -k --output C:\install\StarkeDMS-latest\MicrosoftEdgeEnterpriseX64.msi --create-dirs
Start-Process -wait -FilePath C:\install\StarkeDMS-latest\MicrosoftEdgeEnterpriseX64.msi -ArgumentList "/quiet"

# Uninstall Internet Explorer 11
Write-Host -ForegroundColor Green "echo Uninstall Internet Explorer 11"
Disable-WindowsOptionalFeature -FeatureName Internet-Explorer-Optional-amd64 -Online -NoRestart
Write-Host
Write-Host
Write-Host -ForegroundColor Green "#######################################"
Write-Host -ForegroundColor Green "# Microsoft Edge installed "
Write-Host -ForegroundColor Green "#######################################"
Write-Host
Write-Host


################################################
## create media structure
################################################
Write-Host -ForegroundColor Green "##########################################"
Write-Host -ForegroundColor Green "######## creating media structur #########"
Write-Host -ForegroundColor Green "##########################################"

New-Item -Path "d:\" -Name "dms-data" -ItemType "directory"
New-Item -Path "d:\" -Name "dms-config" -ItemType "directory"
New-Item -Path "d:\dms-data" -Name "documents" -ItemType "directory"
New-Item -Path "d:\dms-data" -Name "mail" -ItemType "directory"
New-Item -Path "d:\dms-data" -Name "pdf-converted" -ItemType "directory"
New-Item -Path "d:\dms-data" -Name "pool" -ItemType "directory"
New-Item -Path "d:\dms-data" -Name "preview" -ItemType "directory"
New-Item -Path "d:\dms-data" -Name "backup" -ItemType "directory"
New-Item -Path "d:\dms-data" -Name "sql" -ItemType "directory"
New-Item -Path "d:\dms-data" -Name "ftp-log" -ItemType "directory"
New-Item -Path "d:\dms-data" -Name "ftp-data" -ItemType "directory"
New-Item -Path "d:\dms-data\backup" -Name "sql" -ItemType "directory"
New-Item -Path "d:\" -Name "tools" -ItemType "directory"
New-Item -Path "d:\tools" -Name "ansible" -ItemType "directory"

################################################
## install FTP server
################################################

Install-WindowsFeature Web-Ftp-Server -IncludeAllSubFeature -IncludeManagementTools
Install-Module -Name IISAdministration -force

Import-Module ServerManager
Add-WindowsFeature Web-Scripting-Tools
import-module WebAdministration

# https://blog.kmsigma.com/2016/02/25/removing-default-web-site-application-pool/
Remove-IISSite "Default Web Site" -Confirm:$False
# Remove-WebAppPool -Name "DefaultAppPool" -Confirm:$false -Verbose

# https://www.server-world.info/en/note?os=Windows_Server_2019&p=ftp&f=2
Set-WebConfiguration "/system.ftpServer/firewallSupport" -PSPath "IIS:\" -Value @{lowDataChannelPort="60000";highDataChannelPort="60100";} 
Restart-Service ftpsvc 

New-NetFirewallRule `
-Name "FTP Server Port" `
-DisplayName "FTP Server Port" `
-Description 'Allow FTP Server Ports' `
-Profile Any `
-Direction Inbound `
-Action Allow `
-Protocol TCP `
-Program Any `
-LocalAddress Any `
-LocalPort 21,60000-60100 

####   https://techexpert.tips/de/powershell-de/powershell-ersetzen-von-text-in-einer-datei/

# moved to Install-Starke-DMS_02.ps1 / 26.11.2022
# https://www.server-world.info/en/note?os=Windows_Server_2019&p=initial_conf&f=1
New-LocalUser -Name $FTPuserName `
-FullName "Starke-DMS Cloud 1.0 FileXchange user" `
-Description "FTP user" `
-Password $FTPUserPassword `
-PasswordNeverExpires `
-AccountNeverExpires 

New-LocalGroup -Name $FTPgroup
Add-LocalGroupMember -Group $FTPgroup -Member $FTPuserName 

mkdir $FTPsitePath 
New-WebFtpSite -Name $FTPsiteShort -IPAddress "*" -Port 21
Set-ItemProperty $FTPsiteFull -Name physicalPath -Value $FTPsitePath
Set-ItemProperty $FTPsiteFull -Name ftpServer.security.ssl.controlChannelPolicy -Value "SslAllow" 
Set-ItemProperty $FTPsiteFull -Name ftpServer.security.ssl.dataChannelPolicy -Value "SslAllow" 
Set-ItemProperty $FTPsiteFull -Name ftpServer.security.authentication.basicAuthentication.enabled -Value $true 

Add-WebConfiguration "/system.ftpServer/security/authorization" -Location $FTPsiteShort -PSPath IIS:\ -Value @{accessType="Allow";roles=$FTPgroup;permissions="Read,Write"} 

icacls $FTPsitePath /grant "FTPGroup:(OI)(CI)(F)" 

Restart-WebItem -PSPath $FTPsiteFull 

Set-ItemProperty $FTPsiteFull -Name ftpServer.security.ssl.controlChannelPolicy -Value "SslAllow" 
Set-ItemProperty $FTPsiteFull -Name ftpServer.security.ssl.dataChannelPolicy -Value "SslAllow" 

# Set-ItemProperty $FTPsiteFull -Name ftpServer.security.ssl.controlChannelPolicy -Value "SslRequire" 
# Set-ItemProperty $FTPsiteFull -Name ftpServer.security.ssl.dataChannelPolicy -Value "SslRequire" 

Set-ItemProperty $FTPsiteFull -Name ftpServer.security.ssl.serverCertStoreName -Value "My" 
Set-ItemProperty $FTPsiteFull -Name ftpServer.security.ssl.serverCertHash -Value (Get-ChildItem -path cert:\LocalMachine\My | Where-Object -Property Subject -like "CN=*").Thumbprint

Remove-Item C:\inetpub\ -recurse


################################################
## install updates
################################################
# Install PSWindowsUpdate Modul for PowerShell
Write-Host 
Write-Host -ForegroundColor Yellow "################################################"
Write-Host -ForegroundColor Yellow "# Install PSWindowsUpdate modul for PowerShell #"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host
# pause

Install-Module -Name PSWindowsUpdate -Force
Start-Sleep -s 2
get-command -module PSWindowsUpdate
Start-Sleep -s 2

# Install all pending Updates and restart without asking
Write-Host 
Write-Host -ForegroundColor Yellow "##########################################################"
Write-Host -ForegroundColor Yellow "# Install all pending updates and restart without asking #"
Write-Host -ForegroundColor Yellow "##########################################################"
Write-Host
# pause
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot


################################################
## restart the computer
################################################
# [Console]::ReadKey()
Restart-computer -force