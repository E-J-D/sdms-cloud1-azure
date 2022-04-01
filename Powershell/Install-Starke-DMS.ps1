# 01.04.2022 Eike Doose / licenced for commerical use only - do not distribute
# ============================================================================

cls
Write-Host -ForegroundColor Yellow "Starke-DMS® and ABBYY will be installed"
for ($i = 100; $i -gt 10; $i-- )
{
    Write-Progress -Activity "Countdown" -Status "$i%" -PercentComplete $i
    Start-Sleep -Milliseconds 25
}
cls
Write-Host -ForegroundColor Red "to cancel press STRG+C - otherwise any key"
pause

# download the latest Starke-DMS® installer
curl.exe "ftp://get--it:get--IT2022@ftp.get--it.de/StarkeDMSlatest.zip" --output C:\install\StarkeDMS-latest\StarkeDMSlatest.zip --create-dirs

# download the latest ABBYY installer
curl.exe "ftp://get--it:get--IT2022@ftp.get--it.de/ABBYYlatest.zip" --output C:\install\StarkeDMS-latest\ABBYYlatest.zip --create-dirs

# expand the Starke-DMS® ZIP
Expand-Archive -LiteralPath C:\install\StarkeDMS-latest\StarkeDMSlatest.zip -DestinationPath C:\install\StarkeDMS-latest

# expand the ABBYY ZIP
Expand-Archive -LiteralPath C:\install\StarkeDMS-latest\ABBYYlatest.zip -DestinationPath C:\install\StarkeDMS-latest

# delete the downloaded ZIPs
Remove-Item C:\install\StarkeDMS-latest\StarkeDMSlatest.zip
Remove-Item C:\install\StarkeDMS-latest\ABBYYlatest.zip

# download predefined installer registry keys
curl.exe "https://raw.githubusercontent.com/E-J-D/sdms-cloud1-azure/main/Powershell/Install-Starke-DMS_setup.reg" --output C:\install\StarkeDMS-latest\StarkeDMS-setup.reg --create-dirs
curl.exe "https://raw.githubusercontent.com/E-J-D/sdms-cloud1-azure/main/Powershell/Install-ABBYY_setup.reg" --output C:\install\StarkeDMS-latest\ABBYY-setup.reg --create-dirs

# import predefined installer registry keys
reg import C:\install\StarkeDMS-latest\StarkeDMS-setup.reg /reg:64
reg import C:\install\StarkeDMS-latest\ABBYY-setup.reg /reg:64

# rename the downloaded installer to *latest
Get-ChildItem -Path C:\install\StarkeDMS-latest\* -Include StarkeDMS*.exe | Rename-Item -NewName StarkeDMS-latest.exe
Get-ChildItem -Path C:\install\StarkeDMS-latest\* -Include ABBYY*.exe | Rename-Item -NewName ABBYY-latest.exe

# run the Starke-DMS® installer in silend mode
Start-Process -Wait -FilePath 'C:\install\StarkeDMS-latest\StarkeDMS-latest.exe' -ArgumentList /S -PassThru

# wait for the Starke-DMS® installer to be finished
Wait-Process -Name Starke*
Start-Sleep -s 10

# run the ABBYY installer in silend mode
Start-Process -Wait -FilePath 'C:\install\StarkeDMS-latest\ABBYY-latest.exe' -ArgumentList /S -PassThru

# wait for the ABBYY installer to be finished
Wait-Process -Name ABBYY*
Start-Sleep -s 5

# message when everything is done
Write-Host -ForegroundColor Yellow "################################################"
Write-Host -ForegroundColor Green  "#############  Everything done  ################"
Write-Host -ForegroundColor Green  "###  Thank you for using www.Starke-DMS.com  ###"
Write-Host -ForegroundColor Yellow "################################################"
