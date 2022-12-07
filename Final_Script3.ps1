cls
# creates variable that imports csv file of list of computers with logi
$serverlist = import-csv -path C:\final_lab\computer_list.csv
# creates loop that creates the report for every erver in the csv file
foreach ($server in $serverlist) {
$username = $server.username
$password = convertto-securestring $server.password -asplaintext -force
$userpass = new-object system.management.automation.pscredential($username,$password)
set-item wsman:\localhost\client\trustedhosts -value * -force
enable-psremoting
invoke-command -computername $server.computername -Credential $userpass -scriptblock {

 
""
"Windows Roles and Features"
#gets product type number and determines if server or workstation
$ProdNum = (get-ciminstance -ClassName win32_operatingsystem).ProductType

#creates report directory if it doesnt exist
$folder= "\\sielaff-client1\c:\report"
if (Test-Path -Path $folder) {""}
else {New-Item "$folder" -ItemType directory}

# If-Else for creating roles and features list
if ($ProdNum -eq 1) {
Write-Output "This is not a server"}

else {
get-windowsfeature | Where-Object {$_.installstate -eq "installed"} | Format-List Name,Installed | more
}

""
"Computer Name"
"--------------------"
""
hostname
""

"OS Version"
"--------------------"
""
#Names the operating System
$os = (Get-CimInstance win32_operatingsystem).Version
$os
""
""
"Processor Information"
"--------------------"
""

#Used to get processor properties
$ProcessorInfo = Get-ciminstance -Class win32_processor
$processor2 = (Get-CimInstance win32_processor).Manufacturer



#Finds the amount of RAM and converts it to GB
$MemoryInfo = (Get-CimInstance win32_physicalmemory | Measure-Object -property capacity -sum).sum /1gb

"Physical Memory in GB: $memoryinfo"


#Displays manufacturer of processor
""
"Manufacturer: $processor2"
""
$ProcessorInfo.name

#Finds number of cores
$ProcessorInfo | ft numberofcores

} 

}

