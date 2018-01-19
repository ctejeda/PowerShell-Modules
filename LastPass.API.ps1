

### LastPass API Data Exporting 
### By Chris Tejeda 
### Date 1/11/2018

$url = "https://lastpass.com/enterpriseapi.php"


$Reporting= @"

{

"cid": "CIDNumberHere",
"provhash": "proHashHere",
"cmd": "reporting"

}

"@ 

$getuserdata= @"

{

"cid": "CIDNumberHere",
"provhash": "proHashHere",
"cmd": "getuserdata"

}

"@ 

$getsfdata= @"

{

"cid": "CIDNumberHere",
"provhash": "proHashHere",
"cmd": "getsfdata"

}

"@ 

Invoke-RestMethod $url -Body $Reporting -UseBasicParsing -Method POST -ContentType "application/Json" | select -ExpandProperty Data |  Export-Csv "c:\temp\LastPass_reporting.csv" -NoTypeInformation
Invoke-RestMethod $url -Body $getuserdata -UseBasicParsing -Method POST -ContentType "application/Json" | select -ExpandProperty Users | Export-Csv "c:\temp\LastPass_GetUserdata.csv" -NoTypeInformation
Invoke-RestMethod $url -Body $getsfdata -UseBasicParsing -Method POST -ContentType "application/Json" | Export-Csv "c:\temp\LastPass_Getsfdata.csv" -NoTypeInformation
