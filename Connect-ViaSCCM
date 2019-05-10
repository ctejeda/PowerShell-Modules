## Connect Via SCCM 
## Chris Tejeda
## 7/2018



Function Connect-ViaSCCM {


[CmdletBinding()]
    param 
    (
        [Parameter(Mandatory=$false)]
        [string]$computer,
        [Parameter(Mandatory=$false)]
        [string]$user,
        [Parameter(Mandatory=$false)]
        [switch]$SendWakePacket,
        [Parameter(Mandatory=$false)]
        [switch]$showPrimaryDeviceOnly,
        [Parameter(Mandatory=$false)]
        [switch]$RunSCCMActions,
        [Parameter(Mandatory=$false)]
        [string]$MacUser
          
    )



Function Invoke-Logger {


    [CmdletBinding()]
    param 
    (
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [Parameter(Mandatory=$true)]
        [string]$LogFile,
        [Parameter(Mandatory=$false)]
        [Switch]$ShowOutput,
        [Parameter(Mandatory=$false)]
        [Switch]$SaveToCSV,
        [Parameter(Mandatory=$false)]
        [Switch]$ShowError,
        [Parameter(Mandatory=$false)]
        [Switch]$ShowWarning
    )
        $date = Get-Date -UFormat "%m/%d/%Y %H:%M:%S"
        $Global:logfile = "$env:USERPROFILE\Set-WindowsVMDiskSpace.log"
        Add-Content $LogFile -Value "$date - $Message"
        if ($ShowOutput)
        {$ShowOutput = Write-Host $Message -ForegroundColor Green }
        if ($ShowError)
        {$ShowError = Write-Host $Message -ForegroundColor Red }
        if ($ShowWarning)
        {$ShowWarning = Write-Host $Message -ForegroundColor Yellow }
        if ($SaveToCSV){$array = @(); $array += [pscustomobject] @{"computer" = $computer; "Message" = "$Message"; "Date" = "$date" }; $array | Export-Csv -Path "$env:USERPROFILE\Set-WindowsVMDiskSpace.csv" -NoTypeInformation }
        $ErrorActionPreference='stop'
        
}
$Global:logfile = "c:\Connect-ViaSCCM.log"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
Function Write-Menu
{
	
	
	[CmdletBinding()]
	[Alias("menu")]
	Param (
		[Parameter(Mandatory, Position = 0)]
		[Alias("MenuEntry", "List")]
		$Menu
		 ,
		[Parameter(Mandatory = $false, Position = 1)]
		[string]$PropertyToShow = 'Name'
		 ,
		[Parameter(Mandatory = $false, Position = 2)]
		[ValidateNotNullorEmpty()]
		[string]$Prompt = 'Pick a choice'
		 ,
		[Parameter(Mandatory = $false, Position = 3)]
		[Alias("Title")]
		[string]$Header = ''
		 ,
		[Parameter(Mandatory = $false, Position = 4)]
		[ValidateRange(0, 5)]
		[Alias("Tab", "MenuShift")]
		[int]$Shift = 0
		 ,
		[Parameter(Mandatory = $false, Position = 5)]
		[Alias("Color", "MenuColor")]
		[System.ConsoleColor]$TextColor = 'White'
		 ,
		[Parameter(Mandatory = $false, Position = 6)]
		[System.ConsoleColor]$HeaderColor = 'Yellow'
		 ,
		[Parameter(Mandatory = $false)]
		[ValidateNotNullorEmpty()]
		[Alias("Exit", "AllowExit")]
		[switch]$AddExit
	)
	
	Begin
	{
		$ErrorActionPreference = 'Stop'
		if ($Menu -isnot [array]) { $Menu = @($Menu) }
		if ($Menu[0] -is [psobject] -and $Menu[0] -isnot [string])
		{
			if (!($Menu | Get-Member -MemberType Property, NoteProperty -Name $PropertyToShow)) { Throw "Property [$PropertyToShow] does not exist" }
		}
		$MaxLength = if ($AddExit) { 8 }
		else { 9 }
		$AddZero = if ($Menu.Length -gt $MaxLength) { $true }
		else { $false }
		[hashtable]$htMenu = @{ }
	}
	Process
	{
		### Write menu header ###
		if ($Header -ne '') { Write-Host $Header -ForegroundColor $HeaderColor }
		
		### Create shift prefix ###
		if ($Shift -gt 0) { $Prefix = [string]"`t" * $Shift }
		
		### Build menu hash table ###
		for ($i = 1; $i -le $Menu.Length; $i++)
		{
			$Key = if ($AddZero)
			{
				$lz = if ($AddExit) { ([string]($Menu.Length + 1)).Length - ([string]$i).Length }
				else { ([string]$Menu.Length).Length - ([string]$i).Length }
				"0" * $lz + "$i"
			}
			else
			{
				"$i"
			}
			
			$htMenu.Add($Key, $Menu[$i - 1])
			
			if ($Menu[$i] -isnot 'string' -and ($Menu[$i - 1].$PropertyToShow))
			{
				Write-Host "$Prefix[$Key] $($Menu[$i - 1].$PropertyToShow)" -ForegroundColor $TextColor
			}
			else
			{
				Write-Host "$Prefix[$Key] $($Menu[$i - 1])" -ForegroundColor $TextColor
			}
		}
		
		### Add 'Exit' row ###
		if ($AddExit)
		{
			[string]$Key = $Menu.Length + 1
			$htMenu.Add($Key, "Exit")
			Write-Host "$Prefix[$Key] Exit" -ForegroundColor $TextColor
		}
		
		### Pick a choice ###
		Do
		{
			$Choice = Read-Host -Prompt $Prompt
			$KeyChoice = if ($AddZero)
			{
				$lz = if ($AddExit) { ([string]($Menu.Length + 1)).Length - $Choice.Length }
				else { ([string]$Menu.Length).Length - $Choice.Length }
				if ($lz -gt 0) { "0" * $lz + "$Choice" }
				else { $Choice }
			}
			else
			{
				$Choice
			}
		}
		Until ($htMenu.ContainsKey($KeyChoice))
	}
	End
	{
		return $htMenu.get_Item($KeyChoice)
	}
	
} 


if ($showPrimaryDeviceOnly)
{
try {
$PWD = pwd
Import-Module "\\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1"
$SCCMserver = "SCCM Server Here"
$SCCMnameSpace = "root\SMS\LIC"
## Change Directory to your SIte Code 
cd SC: -ErrorAction SilentlyContinue
$user = $user
$username = "YourDomain\\$user"
Invoke-Logger -Message "Retriving primary device for $user" -LogFile $logfile -ShowOutput
$usercomputer = Get-WmiObject -Namespace "root\SMS\Site_lic" -Class SMS_UserMachineRelationship -ComputerName $SCCMserver -Filter "UniqueUserName='$UserName' and ResourceClientType='1'" | ? {$_.isactive -eq "True"} | select -ExpandProperty resourcename
 

if ($usercomputer.count -gt 1) 
{

Invoke-Logger -Message "Multiple Devices Detected as primary device for User: $user" -LogFile $logfile -ShowOutput

$usercomputerArray = @()

$usercomputer.split()  | % { 


$Model = Get-WmiObject Win32_Computersystem -ComputerName $_ | select -ExpandProperty Model -ErrorAction SilentlyContinue
$manu = Get-WmiObject Win32_Computersystem -ComputerName $_ | select -ExpandProperty Manufacturer -ErrorAction SilentlyContinue


$usercomputerArray += [pscustomobject] @{"Name" = "$_"; "Model" = "$Model"; "Manufacturer" = "$manu"}
#$usercomputerArray += [pscustomobject] @{"Device" = "$_"}


 }

$usercomputerArray

cd $PWD

}

else 

{
Invoke-Logger -Message "The follwoing Primary device $usercomputer was found for user: $user" -LogFile $logfile -ShowOutput 
cd $PWD

$Model = Get-WmiObject Win32_Computersystem -ComputerName $usercomputer | select -ExpandProperty Model
$manu = Get-WmiObject Win32_Computersystem -ComputerName $usercomputer | select -ExpandProperty Manufacturer

$usercomputerArray = @()
$usercomputerArray += [pscustomobject] @{"Name" = "$usercomputer";"Model" = "$Model"; "Manufacturer" = "$manu"}
#$usercomputerArray += [pscustomobject] @{"Name" = "$usercomputer"}
$usercomputerArray 

}




}
catch {$_}
}
elseif ($user) 
{

$PWD = pwd
## Import the SCCM Powershell Module
Import-Module "\\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1"
$SCCMserver = "SCCM Server"
$SCCMnameSpace = "root\SMS\LIC"
cd LIC: -ErrorAction SilentlyContinue
$username = "YourDomain\\$user"
Invoke-Logger -Message "Retriving primary device for $user" -LogFile $logfile -ShowOutput
$usercomputer = Get-WmiObject -Namespace "root\SMS\Site_lic" -Class SMS_UserMachineRelationship  -ComputerName $SCCMserver  -Filter "UniqueUserName='$UserName' and ResourceClientType='1'" | ? {$_.isactive -eq "True"} | select -ExpandProperty resourcename

if ($usercomputer.count -gt 1) 
{

Invoke-Logger -Message "Multiple Devices Detected as primary device for User: $user" -LogFile $logfile -ShowOutput

$usercomputerArray = @()

$usercomputer.split()  | % { $usercomputerArray += [pscustomobject] @{"Name" = "$_"} }

$pc = Write-Menu -Menu ($usercomputerArray) -Prompt "Choose a Device to Connect to" -TextColor Cyan 

$pcname = $pc.name

Invoke-Logger -Message "The follwoing Primary device $pcname has been selected for user: $user" -LogFile $logfile -ShowOutput
cd $PWD -ErrorAction SilentlyContinue
Invoke-Logger -Message "Connection to $pcname using SCCM Client" -LogFile $logfile -ShowOutput
Start-Process "\Path\To\SCCM\CmRcViewer.exe" "$pcname"
}


else 

{

if ($usercomputer)

{
Invoke-Logger -Message "The follwoing Primary device $usercomputer was found for user: $user" -LogFile $logfile -ShowOutput 
cd $PWD -InformationAction Ignore
Start-Process "\Path\To\SCCM\CmRcViewer.exe" "$usercomputer" 
}

else {Invoke-Logger -Message "No Device Found for user $user" -LogFile $logfile -ShowError}

}




}
elseif (!$SendWakePacket) 
{
Invoke-Logger -Message "Connecting to $computer via SCCM Client" -LogFile $logfile -ShowOutput
Start-Process "\Path\To\SCCM\CmRcViewer.exe" "$computer"
}
elseif ($computer) 
{

$PWD = pwd
## Import SCCM Powershell Module
Import-Module "\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1"
$SCCMserver = "SCCM Server"
$SCCMnameSpace = "root\SMS\LIC"
cd SC: -ErrorAction SilentlyContinue
## Optian mac address for computer
$MACAddress = (Get-WmiObject -Class SMS_R_SYSTEM -Namespace "root\sms\site_LIC" -computerName $SCCMserver | where {$_.Name -eq "$computer"})  | select -ExpandProperty MACAddresses
## Change directory back to power working directory
cd $PWD -InformationAction Ignore
## Send wake packet to PC
$Mac = $MACAddress
$MacByteArray = $Mac -split "[:-]" | ForEach-Object { [Byte] "0x$_"}
[Byte[]] $MagicPacket = (,0xFF * 6) + ($MacByteArray  * 16)
$UdpClient = New-Object System.Net.Sockets.UdpClient
$UdpClient.Connect(([System.Net.IPAddress]::Broadcast),7)
$UdpClient.Send($MagicPacket,$MagicPacket.Length)
$UdpClient.Close()
sleep -Seconds 3

Start-Process "\Path\To\SCCM\CmRcViewer.exe" "$computer"}





else 
{ Invoke-Logger -Message "The Following error has occured: $_" -LogFile $logfile -ShowError}

}
