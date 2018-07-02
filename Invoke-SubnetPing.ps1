Function Invoke-SubnetPing {


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

 if ($reply -eq 'True' ) {Write-Host "Reply from $IP"; $array += [pscustomobject] @{"IP" = $IP; "Status" = "Active"}} else {Write-Host "No Reply from $IP"; $array += [pscustomobject] @{"IP" = $IP; "Status" = "No Reply"}} } 

 $path = $SaveChooser.FileName+"."

 $array 
 Write-Host "Would you like to save the results?" -ForegroundColor Yellow 

 $savereults = Read-Host " ( Y / N ) " 
 Switch ($savereults)
 {
 
 Y {$SaveChooser = New-Object -Typename System.Windows.Forms.SaveFileDialog
$SaveChooser.ShowDialog()
$path = $SaveChooser.FileName+".csv"
$array | Export-Csv -Path $path -NoTypeInformation

}
 N {Write-Host "No, Do not Save results"}
 Default {Export-Csv -Path "c:\temp\Ping_Scan_for_Subnet_$network.csv"}

 }



 }