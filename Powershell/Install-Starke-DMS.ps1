# 07.04.2022 Eike Doose / licenced for commerical use only - do not distribute
# ============================================================================

# parameter sample
# -FTPserver 'ftp.get--it.de' -FTPuser 'get--IT' -FTPpass 'get--IT2022' -customerno '50999' -LIZuser 'dockersetup' -LIZpass 'S3VyendlaWwgUmV2aXZhbCBiZXdlaXNlbiE' -LIZserver 'https://starke-dms-license.azurewebsites.net' -LIZuid '{430F5A1E-1E7D-41DD-AB62-9348DC906B01}' -LIZtargetdir 'd:\dms-config' -saPass 'saAdmin00!' 
# -FTPserver 'ftp.get--it.de' -FTPuser 'get--IT' -FTPpass 'get--IT2022' -customerno '50999' -LIZuser 'dockersetup' -LIZpass 'S3VyendlaWwgUmV2aXZhbCBiZXdlaXNlbiE' -LIZserver 'https://starke-dms-license.azurewebsites.net' -LIZuid '{430F5A1E-1E7D-41DD-AB62-9348DC906B01}' -LIZtargetdir 'd:\dms-config' -saPass 'Admin00!' 

param (
	[string]$FTPserver = 'ftp.get--it.de',
	[Parameter(Mandatory=$true)][string]$FTPuser,
	[Parameter(Mandatory=$true)][string]$FTPpass,
	
	[Parameter(Mandatory=$true)][string]$customerno,

	[Parameter(Mandatory=$true)][string]$LIZuser,
	[Parameter(Mandatory=$true)][string]$LIZpass,
	[string]$LIZserver,
	[string]$LIZuid,
	[string]$LIZtargetdir,
	[string]$LIZcustomerno,

	[Parameter(Mandatory=$true)][string]$saPass
)

# ============================================================================

cls

################################################
## intro and countdown
################################################

Write-Host -ForegroundColor Yellow "#######################################"
Write-Host -ForegroundColor Yellow "Starke-DMS® and ABBYY will be installed"
Write-Host -ForegroundColor Yellow "#######################################"

for ($i = 100; $i -gt 10; $i-- )
{
    Write-Progress -Activity "Countdown" -Status "$i%" -PercentComplete $i
    Start-Sleep -Milliseconds 25
}
cls
Write-Host -ForegroundColor Red "##########################################"
Write-Host -ForegroundColor Red "to cancel press STRG+C - otherwise any key"
Write-Host -ForegroundColor Red "##########################################"
[Console]::ReadKey()


################################################
## rename computer to customerno
################################################

Rename-Computer -NewName SDMSC1-$customerno
## hier muss ein Neustart rein bevor es weitergeht!


################################################
## Download section
################################################

Write-Host -ForegroundColor Green "##########################################"
Write-Host -ForegroundColor Green "######### downloading software ###########"
Write-Host -ForegroundColor Green "##########################################"

# download the licence script
curl.exe "https://raw.githubusercontent.com/E-J-D/sdms-cloud1-azure/main/Powershell/Install-Starke-DMS_licence.ps1" --output C:\install\Install-Starke-DMS_licence.ps1 --create-dirs

# download the DB script
curl.exe "https://raw.githubusercontent.com/E-J-D/sdms-cloud1-azure/main/Powershell/Install-Starke-DMS_DB.ps1" --output C:\install\Install-Starke-DMS_DB.ps1 --create-dirs

# download predefined installer registry keys
curl.exe "https://raw.githubusercontent.com/E-J-D/sdms-cloud1-azure/main/Powershell/Install-Starke-DMS_setup.reg" --output C:\install\StarkeDMS-latest\StarkeDMS-setup.reg --create-dirs
curl.exe "https://raw.githubusercontent.com/E-J-D/sdms-cloud1-azure/main/Powershell/Install-ABBYY_setup.reg" --output C:\install\StarkeDMS-latest\ABBYY-setup.reg --create-dirs

# download the PowerShell7 installer
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/PowerShell-7.2.2-win-x64.msi" --ssl-reqd -k --output C:\install\StarkeDMS-latest\PowerShell-7.2.2-win-x64.msi --create-dirs

# download the Notepad++ installer
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/npp.8.3.3.Installer.x64.exe" --ssl-reqd -k --output C:\install\StarkeDMS-latest\Notepad++Installer.exe --create-dirs

# download the latest Starke-DMS® installer
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/StarkeDMSlatest.zip" --ssl-reqd -k --output C:\install\StarkeDMS-latest\StarkeDMSlatest.zip --create-dirs

# download the latest ABBYY installer
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/ABBYYlatest.zip" --ssl-reqd -k --output C:\install\StarkeDMS-latest\ABBYYlatest.zip --create-dirs

# download the MSOLE DB driver
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/msoledbsql_18.6.3_x64.msi" --ssl-reqd -k --output C:\install\StarkeDMS-latest\msoledbsql_18.6.3_x64.msi --create-dirs

# download the MS ODBC SQL DB driver
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/msodbcsql17.msi" --ssl-reqd -k --output C:\install\StarkeDMS-latest\msodbcsql17.msi --create-dirs

# download the MsSqlCmdLnUtils sqlcmd.exe
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/MsSqlCmdLnUtils.msi" --ssl-reqd -k --output C:\install\StarkeDMS-latest\MsSqlCmdLnUtils.msi --create-dirs

# download the Template DB
curl.exe ftp://""$FTPuser":"$FTPpass"@"$FTPserver"/SQL-DB-CLOUD1MASTER1.bak" --ssl-reqd -k --output C:\install\StarkeDMS-latest\SQL-DB-CLOUD1MASTER1.bak --create-dirs



################################################
## create media structur
################################################

# expand the Starke-DMS® ZIP
Expand-Archive -LiteralPath C:\install\StarkeDMS-latest\StarkeDMSlatest.zip -DestinationPath C:\install\StarkeDMS-latest

# expand the ABBYY ZIP
Expand-Archive -LiteralPath C:\install\StarkeDMS-latest\ABBYYlatest.zip -DestinationPath C:\install\StarkeDMS-latest

# delete the downloaded ZIPs
Remove-Item C:\install\StarkeDMS-latest\StarkeDMSlatest.zip
Remove-Item C:\install\StarkeDMS-latest\ABBYYlatest.zip

# rename the downloaded installer to *latest
Get-ChildItem -Path C:\install\StarkeDMS-latest\* -Include StarkeDMS*.exe | Rename-Item -NewName StarkeDMS-latest.exe
Get-ChildItem -Path C:\install\StarkeDMS-latest\* -Include ABBYY*.exe | Rename-Item -NewName ABBYY-latest.exe


################################################
## import predefined registry keys
################################################

reg import C:\install\StarkeDMS-latest\StarkeDMS-setup.reg /reg:64
reg import C:\install\StarkeDMS-latest\ABBYY-setup.reg /reg:64


################################################
## install all the stuff
################################################

# run the PowerShell7 installer in silent mode
Start-Process -wait -FilePath C:\install\StarkeDMS-latest\PowerShell-7.2.2-win-x64.msi -ArgumentList "/quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1 USE_MU=1 ENABLE_MU=1"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host -ForegroundColor Green  "######### PowerShell 7 installed ###############"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host 
Write-Host  

# run the Notepad++ installer in silent mode
Start-Process -Wait -FilePath 'C:\install\StarkeDMS-latest\Notepad++Installer.exe' -ArgumentList /S -PassThru
Write-Host -ForegroundColor Yellow "################################################"
Write-Host -ForegroundColor Green  "############ Notepad++ installed ###############"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host 
Write-Host  

# run the Starke-DMS® installer in silent mode and wait 3sec
Start-Process -Wait -FilePath 'C:\install\StarkeDMS-latest\StarkeDMS-latest.exe' -ArgumentList /S -PassThru
Start-Sleep -s 3
Write-Host -ForegroundColor Yellow "################################################"
Write-Host -ForegroundColor Green  "########### Starke-DMS® installed ##############"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host 
Write-Host  

# run the ABBYY installer in silent mode and wait 3sec
Start-Process -Wait -FilePath 'C:\install\StarkeDMS-latest\ABBYY-latest.exe' -ArgumentList /S -PassThru
Start-Sleep -s 3
Write-Host -ForegroundColor Yellow "################################################"
Write-Host -ForegroundColor Green  "######### ABBYY engine installed ###############"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host 
Write-Host  

# install MSOLE DB driver
Start-Process -wait C:\install\StarkeDMS-latest\msoledbsql_18.6.3_x64.msi -ArgumentList "IACCEPTMSOLEDBSQLLICENSETERMS=YES /qn"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host -ForegroundColor Green  "########### MSOLEDBSQL installed ###############"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host 
Write-Host  

# install MS ODBC SQL17 driver
Start-Process -wait C:\install\StarkeDMS-latest\msodbcsql17.msi -ArgumentList "IACCEPTMSODBCSQLLICENSETERMS=YES /qn"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host -ForegroundColor Green  "########### MSODBCSQL18 installed ##############"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host 
Write-Host  

# install MS SQL Utils (SQLCMD.exe) toolset
Start-Process -wait C:\install\StarkeDMS-latest\MsSqlCmdLnUtils.msi -ArgumentList "IACCEPTMSSQLCMDLNUTILSLICENSETERMS=YES /qn"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host -ForegroundColor Green  "########### MQOLEDBSQL installed ###############"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host 
Write-Host  

# message when everything is done
Write-Host -ForegroundColor Yellow "################################################"
Write-Host -ForegroundColor Green  "############  Installation done  ###############"
Write-Host -ForegroundColor Green  "###  Thank you for using www.Starke-DMS.com  ###"
Write-Host -ForegroundColor Yellow "################################################"
Write-Host 
Write-Host  



################################################
## create media structur
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




################################################
## Starke-DMS licence download
################################################

c:\install\Install-Starke-DMS_licence.ps1 -username $LIZuser -password $LIZpass -server https://starke-dms-license.azurewebsites.net -uid $LIZuid -targetdir $LIZtargetdir


################################################
## Starke-DMS SQL DB config
################################################

Write-Host -ForegroundColor Yellow "##############################"
Write-Host -ForegroundColor Yellow "SQL database will be installed"
Write-Host -ForegroundColor Yellow "##############################"
Write-Host
Write-Host

for ($i = 100; $i -gt 10; $i-- )
{
    Write-Progress -Activity "Countdown" -Status "$i%" -PercentComplete $i
    Start-Sleep -Milliseconds 25
}
Write-Host -ForegroundColor Yellow "#####################################"
Write-Host -ForegroundColor Yellow "### press any key, CRTL-C to stop ###"
Write-Host -ForegroundColor Yellow "#####################################"
Write-Host
Write-Host

# press any key to continue
[Console]::ReadKey()

# create DMSServer.ini
'[DB]','ConnectionString=Provider=MSOLEDBSQL;SERVER=localhost\SDMSCLOUD1;DATABASE=CLOUD1MASTER1','[Network]','Port=27244','[Lizenz]','File=APLizenz.liz' | out-file d:\dms-config\DMSServer.ini

# create initial DB
Start-Process -wait -filepath "C:\Program Files (x86)\StarkeDMS\win64\DMSServer.exe"  -ArgumentList "-AdminPwd $saPass -cli -dbupdate -configpath $LIZtargetdir"

# CLOUD1MASTER1 restore
sqlcmd -S localhost\SDMSCLOUD1 -U SA -P $saPass -Q "RESTORE DATABASE [CLOUD1MASTER1] FROM  DISK = N'C:\install\StarkeDMS-latest\SQL-DB-CLOUD1MASTER1.bak' WITH  FILE = 1,  MOVE N'CLOUD1MASTER1_Pri' TO N'D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\CLOUD1MASTER1_Pri.mdf',  MOVE N'CLOUD1MASTER1_Dat' TO N'D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\CLOUD1MASTER1_Dat.ndf',  MOVE N'CLOUD1MASTER1_txt' TO N'D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\CLOUD1MASTER1_Txt.ndf',  MOVE N'CLOUD1MASTER1_Log' TO N'D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\CLOUD1MASTER1_Log.ldf',  NOUNLOAD,  REPLACE,  STATS = 5;"

# rename DB to DB$customerno
sqlcmd -S localhost\SDMSCLOUD1 -U SA -P $saPass -Q "ALTER DATABASE CLOUD1MASTER1 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;"
sqlcmd -S localhost\SDMSCLOUD1 -U SA -P $saPass -Q "ALTER DATABASE CLOUD1MASTER1 MODIFY FILE (NAME=N'CLOUD1MASTER1_Pri', NEWNAME=N'$customerno-pri');"
sqlcmd -S localhost\SDMSCLOUD1 -U SA -P $saPass -Q "ALTER DATABASE CLOUD1MASTER1 MODIFY FILE (NAME=N'CLOUD1MASTER1_Log', NEWNAME=N'$customerno-log');"
sqlcmd -S localhost\SDMSCLOUD1 -U SA -P $saPass -Q "ALTER DATABASE CLOUD1MASTER1 MODIFY FILE (NAME=N'CLOUD1MASTER1_Dat', NEWNAME=N'$customerno-dat');"
sqlcmd -S localhost\SDMSCLOUD1 -U SA -P $saPass -Q "ALTER DATABASE CLOUD1MASTER1 MODIFY FILE (NAME=N'CLOUD1MASTER1_Txt', NEWNAME=N'$customerno-txt');"
sqlcmd -S localhost\SDMSCLOUD1 -U SA -P $saPass -Q "EXEC master.dbo.sp_detach_db @dbname = N'CLOUD1MASTER1'"

# rename DB files 
Get-ChildItem D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\CLOUD1MASTER1* | Rename-Item -NewName { $_.Name -replace '_','-' }
Get-ChildItem D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\CLOUD1MASTER1* | Rename-Item -NewName { $_.Name -replace 'CLOUD1MASTER1',$customerno }

# create renamed DB
sqlcmd -S localhost\SDMSCLOUD1 -U SA -P $saPass -Q "CREATE DATABASE CLOUD1MASTER1 ON ( FILENAME = N'D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\$customerno-pri.mdf' ), ( FILENAME = N'D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\$customerno-log.ldf' ), ( FILENAME = N'D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\$customerno-dat.ndf' ), ( FILENAME = N'D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\$customerno-txt.ndf' ) FOR ATTACH;"
sqlcmd -S localhost\SDMSCLOUD1 -U SA -P $saPass -Q "ALTER DATABASE CLOUD1MASTER1 SET MULTI_USER;"
sqlcmd -S localhost\SDMSCLOUD1 -U SA -P $saPass -Q "ALTER DATABASE CLOUD1MASTER1 MODIFY NAME = [$customerno];"

# change DB in DMSServer.ini to new DB name
'[DB]',"ConnectionString=Provider=MSOLEDBSQL;SERVER=localhost\SDMSCLOUD1;DATABASE=$customerno",'[Network]','Port=27244','[Lizenz]','File=APLizenz.liz' | out-file d:\dms-config\DMSServer.ini

# fix DB to new customer
C:\install\Install-Starke-DMS_DBfixLic.ps1 -sqlserver localhost\SDMSCLOUD1 -database $customerno -username 'sa' -password $saPass -configpath $LIZtargetdir

# update system DB user
sqlcmd -S localhost\SDMSCLOUD1 -U SA -d $customerno -P $saPass -Q "ALTER USER ArchivPlus WITH LOGIN = ArchivPlus;"


# ## kann gelöscht werden, wenn Funktion vorher getestet ###
# ## kann gelöscht werden, wenn Funktion vorher getestet ###
# ## kann gelöscht werden, wenn Funktion vorher getestet ###
# ## kann gelöscht werden, wenn Funktion vorher getestet ###

# create the SQL DB
# DMS-2282 DMSServer Datenbankerstellung und Update ohne Oberflächenabfragen alles über Kommandozeilenparameter steuern
# https://starke.atlassian.net/browse/DMS-2282
#'[DB]','ConnectionString=Provider=MSOLEDBSQL;SERVER=localhost\SDMSCLOUD1;DATABASE=CLOUD1MASTER1','[Network]','Port=27244','[Lizenz]','File=APLizenz.liz' | out-file d:\dms-config\DMSServer.ini
#Start-Process -wait -filepath "C:\Program Files (x86)\StarkeDMS\win64\DMSServer.exe"  -ArgumentList "-AdminPwd $saPass -cli -dbupdate -configpath $LIZtargetdir"


################################################
## restore template DB to new installation
################################################

##sqlcmd -S localhost\SDMSCLOUD1 -U SA -P $saPass -Q "RESTORE DATABASE [CLOUD1MASTER1] FROM DISK = 'c:\install\StarkeDMS-latest\SQL-DB-CLOUD1MASTER1.bak' WITH CHECKSUM, FILE = 1, NOUNLOAD, REPLACE, NORECOVERY, STATS = 5, MOVE 'CLOUD1MASTER1_Pri' TO 'D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\CLOUD1MASTER1_Pri.mdf', MOVE 'CLOUD1MASTER1_Log' TO 'D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\CLOUD1MASTER1_Log.ldf', MOVE 'CLOUD1MASTER1_Txt' TO 'D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\CLOUD1MASTER1_Txt.ndf',MOVE 'CLOUD1MASTER1_Dat' TO 'D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\CLOUD1MASTER1_Dat.ndf';"
#sqlcmd -S localhost\SDMSCLOUD1 -U SA -P $saPass -Q "RESTORE DATABASE [CLOUD1MASTER1] FROM  DISK = N'C:\install\StarkeDMS-latest\SQL-DB-CLOUD1MASTER1.bak' WITH  FILE = 1,  MOVE N'CLOUD1MASTER1_Pri' TO N'D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\CLOUD1MASTER1_Pri.mdf',  MOVE N'CLOUD1MASTER1_Dat' TO N'D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\CLOUD1MASTER1_Dat.ndf',  MOVE N'CLOUD1MASTER1_txt' TO N'D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\CLOUD1MASTER1_Txt.ndf',  MOVE N'CLOUD1MASTER1_Log' TO N'D:\dms-data\sql\MSSQL15.SDMSCLOUD1\MSSQL\DATA\CLOUD1MASTER1_Log.ldf',  NOUNLOAD,  REPLACE,  STATS = 5;"


# ## kann gelöscht werden, wenn Funktion vorher getestet ###
# ## kann gelöscht werden, wenn Funktion vorher getestet ###
# ## kann gelöscht werden, wenn Funktion vorher getestet ###
# ## kann gelöscht werden, wenn Funktion vorher getestet ###
# BIS HIER



################################################
## Starke-DMS services config
## https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/new-service?view=powershell-7.2
################################################

# DMS Server service install
# --------------------------
Write-Host -ForegroundColor Yellow "####################################"
Write-Host -ForegroundColor Yellow "DMS Server Service will be installed"
Write-Host -ForegroundColor Yellow "####################################"
Write-Host
Write-Host -ForegroundColor Yellow "#########  press any key  ##########"

# press any key to continue
[Console]::ReadKey()

pause
$params = @{
  Name = "DMS_Cloud1Master1_01_Server"
  BinaryPathName = 'C:\Program Files (x86)\StarkeDMS\win64\DMSServerSvc.exe /name "DMS_Cloud1Master1_01_Server" /ini DMSServer.ini /configpath "d:\dms-config"'
  StartupType = "AutomaticDelayedStart"
  Description = "Starke-DMS Server"
}
New-Service @params



# DMS LicenseManager service install
# ----------------------------------
Write-Host -ForegroundColor Yellow "############################################"
Write-Host -ForegroundColor Yellow "DMS LicenceManager service will be installed"
Write-Host -ForegroundColor Yellow "############################################"
Write-Host
Write-Host -ForegroundColor Yellow "#############  press any key  ##############"

# press any key to continue
[Console]::ReadKey()

#'[DB]','ConnectionString=Provider=MSOLEDBSQL;SERVER=localhost\SDMSCLOUD1;DATABASE=$customerno,'[Network]','Port=27244','[Lizenz]','File=APLizenz.liz' | out-file d:\dms-config\DMSLicenseManager.ini
'[Service]','User=system','Password=system','Server=localhost','Port=27244' | out-file d:\dms-config\DMSLicenseManager.ini


$params = @{
  Name = "DMS_Cloud1Master1_02_LicenseManager"
  BinaryPathName = 'C:\Program Files (x86)\StarkeDMS\win64\DMSLizenzmanagerSvc.exe /name "DMS_Cloud1Master1_02_LicenseManager" /Ini "DMSLicenseManager.ini" /ConfigPath "D:\dms-config"'
  StartupType = "AutomaticDelayedStart"
  Description = "Starke-DMS License Manager"
  DependsOn = "DMS_Cloud1Master1_01_Server"
}
New-Service @params



# DMS xyz service install
# ----------------------------------

Write-Host -ForegroundColor Yellow "############################################"
Write-Host -ForegroundColor Yellow "DMS xyz  service will be installed"
Write-Host -ForegroundColor Yellow "############################################"
Write-Host
Write-Host -ForegroundColor Yellow "#############  press any key  ##############"

# press any key to continue
[Console]::ReadKey()




################################################
## cleaning up
################################################

# delete DMS setup.exe 
Remove-Item C:\Program Files (x86)\StarkeDMS\setup\setup.exe
#Remove-Item C:\install\StarkeDMS-latest\*
#Remove-Item C:\install\*



################################################
## restart computer
################################################
Write-Host -ForegroundColor Red "################################################"
Write-Host -ForegroundColor Red "## Computer will be restarted - press any key ##"
Write-Host -ForegroundColor Red "################################################"
Write-Host
Write-Host -ForegroundColor Yellow "#############  press any key  ##############"
[Console]::ReadKey()
Restart-computer -force