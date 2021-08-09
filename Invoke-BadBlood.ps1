<#
    .Synopsis
       Generates users, groups, OUs, computers in an active directory domain.  Then places ACLs on random OUs
    .DESCRIPTION
       This tool is for research purposes and training only.  Intended only for personal use.  This adds a large number of objects into a domain, and should never be  run in production.
    .EXAMPLE
       There are currently no parameters for the tool.  Simply run the ps1 as a DA and it begins. Follow the prompts and type 'badblood' when appropriate and the tool runs.
    .OUTPUTS
       [String]
    .NOTES
       Written by David Rowe, Blog secframe.com
       Twitter : @davidprowe
       I take no responsibility for any issues caused by this script.  I am not responsible if this gets run in a production domain. 
      Thanks HuskyHacks for user/group/computer count modifications.  I moved them to parameters so that this tool can be called in a more rapid fashion.
    .FUNCTIONALITY
       Adds a ton of stuff into a domain.  Adds Users, Groups, OUs, Computers, and a vast amount of ACLs in a domain.
    .LINK
       http://www.secframe.com/badblood
   
    #>
[CmdletBinding()]
    
param
(
   [Parameter(Mandatory = $false,
      Position = 1,
      HelpMessage = 'Supply a count for user creation default 2500')]
   [Int32]$UserCount = 2500,
   [Parameter(Mandatory = $false,
      Position = 2,
      HelpMessage = 'Supply a count for user creation default 500')]
   [int32]$GroupCount = 500,
   [Parameter(Mandatory = $false,
      Position = 3,
      HelpMessage = 'Supply the script directory for where this script is stored')]
   [int32]$ComputerCount = 100,
   [Parameter(Mandatory = $false,
      Position = 4,
      HelpMessage = 'Skip the OU creation if you already have done it')]
   [switch]$SkipOuCreation,
   [Parameter(Mandatory = $false,
      Position = 5,
      HelpMessage = 'Skip the LAPS deployment if you already have done it')]
   [switch]$SkipLapsInstall,
   [Parameter(Mandatory = $false,
      Position = 6,
      HelpMessage = 'Make non-interactive for automation')]
   [switch]$NonInteractive
)
function Get-ScriptDirectory {
   Split-Path -Parent $PSCommandPath
}
$basescriptPath = Get-ScriptDirectory
$totalscripts = 8

$i = 0
Clear-host
write-host "Welcome to BadBlood"
if($NonInteractive -eq $false){
    Write-Host  'Press any key to continue...';
    write-host "`n"
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
}
write-host "The first tool that absolutely mucks up your TEST domain"
write-host "This tool is never meant for production and can totally screw up your domain"

if($NonInteractive -eq $false){
    Write-Host  'Press any key to continue...';
    write-host "`n"
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
}
Write-Host  'Press any key to continue...';
write-host "You are responsible for how you use this tool. It is intended for personal use only"
write-host "This is not intended for commercial use"
if($NonInteractive -eq $false){
    Write-Host  'Press any key to continue...';
    write-host "`n"
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
}
write-host "`n"
write-host "Domain size generated via parameters `n Users: $UserCount `n Groups: $GroupCount `n Computers: $ComputerCount"
write-host "`n"
$badblood = "badblood"
if($NonInteractive -eq $false){

    $badblood = Read-Host -Prompt "Type `'badblood`' to deploy some randomness into a domain"
    $badblood.tolower()
    if ($badblood -ne 'badblood') { exit }
}
if ($badblood -eq 'badblood') {

   $Domain = Get-addomain

   # LAPS STUFF
   if ($PSBoundParameters.ContainsKey('SkipLapsInstall') -eq $false)
      {
         Write-Progress -Activity "Random Stuff into A domain" -Status "Progress:" -PercentComplete ($i / $totalscripts * 100)
         .($basescriptPath + '\AD_LAPS_Install\InstallLAPSSchema.ps1')
         Write-Progress -Activity "Random Stuff into A domain: Install LAPS" -Status "Progress:" -PercentComplete ($i / $totalscripts * 100)
      }
   else{}
   
   $I++


   #OU Structure Creation
   if ($PSBoundParameters.ContainsKey('SkipOuCreation') -eq $false)
      {
         .($basescriptPath + '\AD_OU_CreateStructure\CreateOUStructure.ps1')
         Write-Progress -Activity "Random Stuff into A domain - Creating OUs" -Status "Progress:" -PercentComplete ($i / $totalscripts * 100)
      }
   else{}
   $I++

   
   # User Creation
   $ousAll = Get-adorganizationalunit -filter *
   write-host "Creating Users on Domain" -ForegroundColor Green
    
   
   Write-Progress -Activity "Random Stuff into A domain - Creating Users" -Status "Progress:" -PercentComplete ($i / $totalscripts * 100)
   $I++
   
   .($basescriptPath + '\AD_Users_Create\CreateUsers.ps1')
   $createuserscriptpath = $basescriptPath + '\AD_Users_Create\'
   do {
      createuser -Domain $Domain -OUList $ousAll -ScriptDir $createuserscriptpath
      Write-Progress -Activity "Random Stuff into A domain - Creating $UserCount Users" -Status "Progress:" -PercentComplete ($x / $UserCount * 100)
      $x++
   }while ($x -lt $UserCount)

  #Group Creation
   $AllUsers = Get-aduser -Filter *
   write-host "Creating Groups on Domain" -ForegroundColor Green

   $x = 1
   Write-Progress -Activity "Random Stuff into A domain - Creating $GroupCount Groups" -Status "Progress:" -PercentComplete ($i / $totalscripts * 100)
   $i++
   .($basescriptPath + '\AD_Groups_Create\CreateGroup.ps1')
   $createGroupScriptPath = $basescriptPath + '\AD_Groups_Create\'
    
   do {
      Creategroup -Domain $Domain -OUList $ousAll -UserList $AllUsers -ScriptDir $createGroupScriptPath
      Write-Progress -Activity "Random Stuff into A domain - Creating $GroupCount Groups" -Status "Progress:" -PercentComplete ($x / $GroupCount * 100)
      $x++
   }while ($x -lt $GroupCount)
   $Grouplist = Get-ADGroup -Filter { GroupCategory -eq "Security" -and GroupScope -eq "Global" } -Properties isCriticalSystemObject
   $LocalGroupList = Get-ADGroup -Filter { GroupScope -eq "domainlocal" } -Properties isCriticalSystemObject
   
   #Computer Creation Time
   write-host "Creating Computers on Domain" -ForegroundColor Green

   $X = 1
   Write-Progress -Activity "Random Stuff into A domain - Creating Computers" -Status "Progress:" -PercentComplete ($i / $totalscripts * 100)
   .($basescriptPath + '\AD_Computers_Create\CreateComputers.ps1')
   $I++
   do {
      Write-Progress -Activity "Random Stuff into A domain - Creating $ComputerCount computers" -Status "Progress:" -PercentComplete ($x / $ComputerCount * 100)
      createcomputer
      $x++
   }while ($x -lt $ComputerCount)
   $Complist = get-adcomputer -filter *
    

   #Permission Creation of ACLs
   $I++
   write-host "Creating Permissions on Domain" -ForegroundColor Green
   Write-Progress -Activity "Random Stuff into A domain - Creating Random Permissions" -Status "Progress:" -PercentComplete ($i / $totalscripts * 100)
   .($basescriptPath + '\AD_Permissions_Randomizer\GenerateRandomPermissions.ps1')
    
    
   # Nesting of objects
   $I++
   write-host "Nesting objects into groups on Domain" -ForegroundColor Green
   .($basescriptPath + '\AD_Groups_Create\AddRandomToGroups.ps1')
   Write-Progress -Activity "Random Stuff into A domain - Adding Stuff to Stuff and Things" -Status "Progress:" -PercentComplete ($i / $totalscripts * 100)
   AddRandomToGroups -Domain $Domain -Userlist $AllUsers -GroupList $Grouplist -LocalGroupList $LocalGroupList -complist $Complist

   # ATTACK Vector Automation

   # SPN Generation
   $I++
   write-host "Adding random SPNs to a few User and Computer Objects" -ForegroundColor Green
   Write-Progress -Activity "SPN Stuff Now" -Status "Progress:" -PercentComplete ($i / $totalscripts * 100)
   .($basescriptpath + '\AD_Attack_Vectors\AD_SPN_Randomizer\CreateRandomSPNs.ps1')
   CreateRandomSPNs -SPNCount 50

   write-host "Adding ASREP for a few users" -ForegroundColor Green
   Write-Progress -Activity "Adding ASREP Now" -Status "Progress:" -PercentComplete ($i / $totalscripts * 100)
   # get .05 percent of the all users output and asrep them
   $ASREPCount = [Math]::Ceiling($AllUsers.count * .05)
   $ASREPUsers = @()
   $asrep = 1
   do {

      $ASREPUsers += get-random($AllUsers)
      $asrep++}while($asrep -le $ASREPCount)

   .($basescriptpath + '\AD_Attack_Vectors\ASREP_NotReqPreAuth.ps1')
   ADREP_NotReqPreAuth -UserList $ASREPUsers
      <#
   write-host "Adding Weak User Passwords for a few users" -ForegroundColor Green
   Write-Progress -Activity "Adding Weak User Passwords" -Status "Progress:" -PercentComplete ($i / $totalscripts * 100)
   # get .05 percent of the all users output and asrep them
   $WeakCount = [Math]::Ceiling($AllUsers.count * .02)
   $WeakUsers = @()
   $asrep = 1
   do {

      $WeakUsers += get-random($AllUsers)
      $asrep++}while($asrep -le $WeakCount)

   .($basescriptpath + '\AD_Attack_Vectors\WeakUserPasswords.ps1')
   WeakUserPasswords -UserList $WeakUsers
    #>


}
# $Definition = Get-Content Function:\CreateUser -ErrorAction Stop
   <#
   Attempt at multi threading.  Issues with AD Limits and connections per user per second.
   #Add custom function to runspace pool https://devblogs.microsoft.com/scripting/powertip-add-custom-function-to-runspace-pool/
   $Definition = Get-Content ($basescriptPath + '\AD_Users_Create\CreateUsers.ps1') -ErrorAction Stop
   #Create a sessionstate function entry
   $SessionStateFunction = New-Object System.Management.Automation.Runspaces.SessionStateFunctionEntry -ArgumentList ‘CreateUser’, $Definition
   #Create a SessionStateFunction
   $InitialSessionState = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
   $initialSessionState.ImportPSModule("ActiveDirectory")
   $InitialSessionState.Commands.Add($SessionStateFunction)

   $RunspacePool = [RunspaceFactory]::CreateRunspacePool(1,5,$InitialSessionState,$Host)
   $RunspacePool.Open()
   $runspaces = $results = @()
   do {
     
      $PowerShell = [powershell]::Create()
      [void]$PowerShell.AddScript({CreateUser})
      [void]$PowerShell.AddArgument($Domain)
      [void]$PowerShell.AddArgument($ousAll)
      [void]$PowerShell.AddArgument($createuserscriptpath)
      $PowerShell.RunspacePool = $RunspacePool
      $runspaces += [PSCustomObject]@{ Pipe = $PowerShell; Status = $PowerShell.BeginInvoke() }
      #$runspaces.pipe.streams.error
      
      # $Jobs += $PowerShell.BeginInvoke()
       $x++

   }while ($x -lt $UserCount)

   while ($runspaces.status.IsCompleted -notcontains $true) {
        
   }

   foreach ($runspace in $runspaces ) {
      # EndInvoke method retrieves the results of the asynchronous call
      $results += $runspace.Pipe.EndInvoke($runspace.Status)
      $runspace.Pipe.Dispose()
  }
  $RunspacePool.Close() 
   $RunspacePool.Dispose()

   #Group Creation
   $I++
   $AllUsers = Get-aduser -Filter *
   Write-Progress -Activity "Random Stuff into A domain - Creating Groups" -Status "Progress:" -PercentComplete ($i / $totalscripts * 100)
   write-host "Creating Groups on Domain" -ForegroundColor Green

   $x = 1
   .($basescriptPath + '\AD_Groups_Create\CreateGroup.ps1')
   
   #Create a SessionStateFunction
  
   

   $createGroupScriptPath = $basescriptPath + '\AD_Groups_Create\'
   $Definition = Get-Content Function:\CreateGroup -ErrorAction Stop
   # $Definition = Get-Content ($basescriptPath + '\AD_Groups_Create\CreateGroup.ps1') -ErrorAction Stop

   #Create a sessionstate function entry
   $SessionStateFunction = New-Object System.Management.Automation.Runspaces.SessionStateFunctionEntry -ArgumentList ‘CreateGroup’, $Definition
   #Create a SessionStateFunction
   $InitialSessionState = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
   $initialSessionState.ImportPSModule("ActiveDirectory")
   $InitialSessionState.Commands.Add($SessionStateFunction)

   $RunspacePool = [RunspaceFactory]::CreateRunspacePool(1,5,$InitialSessionState,$Host)
   $RunspacePool.Open()
   $runspaces = $results = @()
   do {
      $PowerShell = [powershell]::Create()
      [void]$PowerShell.AddScript({CreateGroup})
      [void]$PowerShell.AddArgument($Domain)
      [void]$PowerShell.AddArgument($ousAll)
      [void]$PowerShell.AddArgument($AllUsers)
      [void]$PowerShell.AddArgument($createGroupScriptPath)
      $PowerShell.RunspacePool = $RunspacePool
      $runspaces += [PSCustomObject]@{ Pipe = $PowerShell; Status = $PowerShell.BeginInvoke() }

      $x++
   }while ($x -lt $GroupCount)
   while ($runspaces.Status.IsCompleted -notcontains $true) {
        
   }
   foreach ($runspace in $runspaces ) {
      # EndInvoke method retrieves the results of the asynchronous call
      $results += $runspace.Pipe.EndInvoke($runspace.Status)
      $runspace.Pipe.Dispose()
  }
  $RunspacePool.Close() 
   $RunspacePool.Dispose()


   $Grouplist = Get-ADGroup -Filter { GroupCategory -eq "Security" -and GroupScope -eq "Global" } -Properties isCriticalSystemObject
   $LocalGroupList = Get-ADGroup -Filter { GroupScope -eq "domainlocal" } -Properties isCriticalSystemObject

   #Computer Creation Time
   write-host "Creating Computers on Domain" -ForegroundColor Green
   $I++
   $X = 1
   $Jobs = @()
   Write-Progress -Activity "Random Stuff into A domain - Creating Computers" -Status "Progress:" -PercentComplete ($i / $totalscripts * 100)
   # .($basescriptPath + '\AD_Computers_Create\CreateComputers.ps1')
    #Create a sessionstate function entry
    
    $Definition = Get-Content ($basescriptPath + '\AD_Computers_Create\CreateComputers.ps1') -ErrorAction Stop
    $SessionStateFunction = New-Object System.Management.Automation.Runspaces.SessionStateFunctionEntry -ArgumentList ‘CreateComputer’, $Definition
    #Create a SessionStateFunction
    $InitialSessionState = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
    $initialSessionState.ImportPSModule("ActiveDirectory")
    $InitialSessionState.Commands.Add($SessionStateFunction)
 
    $RunspacePool = [RunspaceFactory]::CreateRunspacePool(1,5,$InitialSessionState,$Host)
    $RunspacePool.Open()
    $runspaces = $results = @()

   do {
      $PowerShell = [powershell]::Create()
      [void]$PowerShell.AddScript({CreateComputer})
      $PowerShell.RunspacePool = $RunspacePool
      $runspaces += [PSCustomObject]@{ Pipe = $PowerShell; Status = $PowerShell.BeginInvoke() }

      $x++
   }while ($x -lt $ComputerCount)
   while ($runspaces.Status.IsCompleted -notcontains $true) {
        
   }
   foreach ($runspace in $runspaces ) {
      # EndInvoke method retrieves the results of the asynchronous call
      $results += $runspace.Pipe.EndInvoke($runspace.Status)
      $runspace.Pipe.Dispose()
  }
  $RunspacePool.Close() 
   $RunspacePool.Dispose()
#>