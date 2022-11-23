# 22.11.2022 Eike Doose / INTERNAL USER ONLY / do not distribute
# create ranndom password according to SDMS cloud security guideline
# https://www.active-directory-faq.de/2016/05/powershell-zufaelliges-passwort-nach-eigenen-vorgaben-generieren/
# =========================================================================================

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

# Write-Host $password

$password = Scramble-String $password

Write-Host -ForegroundColor Green "########################################"
Write-Host -ForegroundColor Green "##### Starke-DMS® cloud installer ######"
Write-Host -ForegroundColor Green "### use is as the new admin password ###"
Write-Host -ForegroundColor Green "########################################"
Write-Host -ForegroundColor Green "########################################"
Write-Host -ForegroundColor red   "###########" $password "###########"
Write-Host -ForegroundColor Green "########################################"
Write-Host -ForegroundColor Green "########################################"

Set-LocalUser -Name Administrator -Password $password –Verbose

# rename "Administrator" to "GottliebKrause"
# Rename-LocalUser -Name "Administrator"  -NewName "GottliebKrause"
# Get-LocalUser 

