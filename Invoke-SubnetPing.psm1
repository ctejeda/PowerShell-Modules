## Invoke-Subnet Ping
## By: Chris Tejeda
## 7/2/2018
## Ping a range of IP's in a subnet. 


Function Invoke-SubnetPing {

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
param(

[cmdletbinding()]

    [parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)] 
    [string]$StaringIP,
    [parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)] 
    [string]$EndingIP
    
    )


$array = @()
$startrange = $StaringIP.Split(".") | select -Last 1
$endrange = $endingIP.Split(".") | select -Last 1
$network = $StaringIP.substring(0,$subnet)
$IPByte = $StaringIP.Split(".")
$network = ($IPByte[0]+"."+$IPByte[1]+"."+$IPByte[2])



$startrange..$endrange | % { $IP = $network +"."+ $_ ;$reply = Test-Connection -ComputerName "$IP" -Count 1 -Quiet

 if ($reply -eq 'True' ) {Write-Host "Reply from $IP" -ForegroundColor Green; $array += [pscustomobject] @{"IP" = $IP; "Status" = "Active"}} else {Write-Host "No Reply from $IP"-ForegroundColor Red ; $array += [pscustomobject] @{"IP" = $IP; "Status" = "No Reply"}} } 

 
 $array 
 Write-Host "Would you like to save the results?" -ForegroundColor Yellow 

 $savereults = Read-Host " ( Y / N ) " 
 Switch ($savereults)
 {
 
 Y {$SaveChooser = New-Object -Typename System.Windows.Forms.SaveFileDialog
$SaveChooser.ShowDialog()
$path = $SaveChooser.FileName+".csv"
$array | Export-Csv -Path $path -NoTypeInformation
Write-Host "Your results where saved in the following directory $path"
}

 N {Write-Host "Results not Saved"}
 Default {$array | Export-Csv -Path "c:\temp\Ping_Scan_for_Subnet_$network.csv" -NoTypeInformation }

 }

  }
