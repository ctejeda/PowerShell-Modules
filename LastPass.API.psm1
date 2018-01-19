

### LastPass API Data Exporting 
### By Chris Tejeda 
### Date 1/11/2018




$Global:url = "https://lastpass.com/enterpriseapi.php"
$Global:cidNumber = Read-Host -AssecureString "Enter Your CID number"
$Global:prohashnumber = Read-Host -AsSecureString "Enter Your ProHash Number"



Function Invoke-LastPassAPI {
param(



[switch]$QueryReporting,
[switch]$QueryUserData,
[switch]$QuerySFData


)


if($QueryReporting) {$Reporting= @"

{

"cid": "$cidNumber",
"provhash": "$prohashnumber",
"cmd": "reporting"

}

"@ ; Invoke-RestMethod $url -Body $Reporting -UseBasicParsing -Method POST -ContentType "application/Json"}



elseif ($QueryUserData) {$getuserdata= @"

{

"cid": "$cidNumber",
"provhash": "$prohashnumber",
"cmd": "getuserdata"

}

"@ ;Invoke-RestMethod $url -Body $getuserdata -UseBasicParsing -Method POST -ContentType "application/Json"}



elseif ($QuerySFData) {$getsfdata= @"

{

"cid": "$cidnumber",
"provhash": "$prohashnumber",
"cmd": "getsfdata"

}

"@ ; Invoke-RestMethod $url -Body $getsfdata -UseBasicParsing -Method POST -ContentType "application/Json" }

else {Write-Error "Missing Switch or Paramater"}










}