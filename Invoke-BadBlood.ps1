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
       Written by David Rowe, Blog secframe.com/blog
       Twitter : @davidprowe
       Domain Size Selector by HuskyHacks
       I take no responsibility for any issues caused by this script.  I am not responsible if this gets run in a production domain.  
    .FUNCTIONALITY
       Adds a ton of stuff into a domain.  Adds Users, Groups, OUs, Computers, and a vast amount of ACLs in a domain.
    .LINK
       http://www.secframe.com/badblood
   
    #>

function Get-ScriptDirectory {
    Split-Path -Parent $PSCommandPath
}
$basescriptPath = Get-ScriptDirectory
$totalscripts = 7

$i = 0
cls
write-host "Welcome to BadBlood"
Write-Host  'Press any key to continue...';
write-host "`n"
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
write-host "The first tool that absolutely mucks up your TEST domain"
write-host "This tool is never meant for production and can totally screw up your domain"
Write-Host  'Press any key to continue...';
write-host "`n"
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
Write-Host  'Press any key to continue...';
write-host "You are responsible for how you use this tool. It is intended for personal use only"
write-host "This is not intended for commercial use"
Write-Host  'Press any key to continue...';
write-host "`n"
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

Write-Host  'Please select the SIZE of the domain that you want to create.';
Write-Host  'S - SMALL';
Write-Host  'M - MEDIUM'
Write-Host  'L - LARGE';
Write-Host  'X - X-LARGE';

$choices = [Management.Automation.Host.ChoiceDescription[]] @(
  New-Object Management.Automation.Host.ChoiceDescription("&S","SMALL: 10 to 100 users, 5 to 15 groups, 10 to 30 computers.")
  New-Object Management.Automation.Host.ChoiceDescription("&M","MEDIUM: 100 to 1000 users, 15 to 100 groups, 10 to 30 computers.")
  New-Object Management.Automation.Host.ChoiceDescription("&L","LARGE: 1000 to 5000 users, 100 to 500 groups, 50 to 150 computers.")
  New-Object Management.Automation.Host.ChoiceDescription("&X","X-LARGE: 5000 to 5000 users, 500 to 750 groups, 150 to 400 computers.")
)
$domainsize = $Host.UI.PromptForChoice("Please select a size","`n",$choices,2)

if ($domainsize -ieq "0") {
    $userSize = 10..100|Get-Random ;
    $groupSize = 5..15|Get-Random ;
    $compNum = 10..30|Get-Random
   }

if($domainsize -ieq "1")
   {$userSize = 100..1000|Get-Random;
   $groupSize = 15..100|Get-Random;
   $compNum = 30..150|Get-Random;
   }

if($domainsize -ieq "2")
{$userSize = 1000..5000|Get-Random;
$groupSize = 100..500|Get-Random;
$compNum = 50..150|Get-Random
}

 if($domainsize -ieq "3")
{$userSize = 5000..10000|Get-Random;
$groupSize = 500..750|Get-Random;
$compNum = 150..400| Get-Random
}

write-host "`n"
write-host "Domain size selected! `n Users: $userSize `n Groups: $groupSize `n Computers: $compNum"
write-host "`n"

$badblood = Read-Host -Prompt "Type `'badblood`' to deploy some randomness into a domain"
$badblood.tolower()
if($badblood -ne 'badblood'){exit}
if($badblood -eq 'badblood'){
   $Domain = Get-addomain
    Write-Progress -Activity "Random Stuff into A domain" -Status "Progress:" -PercentComplete ($i/$totalscripts*100)
    .($basescriptPath + '\AD_LAPS_Install\InstallLAPSSchema.ps1')
    Write-Progress -Activity "Random Stuff into A domain: Install LAPS" -Status "Progress:" -PercentComplete ($i/$totalscripts*100)
    $I++
    .($basescriptPath + '\AD_OU_CreateStructure\CreateOUStructure.ps1')
    Write-Progress -Activity "Random Stuff into A domain - Creating OUs" -Status "Progress:" -PercentComplete ($i/$totalscripts*100)
    $I++
    $ousAll = Get-adorganizationalunit -filter *
    write-host "Creating Users on Domain" -ForegroundColor Green
    $NumOfUsers = $userSize #this number is the random number of users to create on a domain.  Todo: Make process createusers.ps1 in a parallel loop
    $X=1
    Write-Progress -Activity "Random Stuff into A domain - Creating Users" -Status "Progress:" -PercentComplete ($i/$totalscripts*100)
    $I++
    .($basescriptPath + '\AD_Users_Create\CreateUsers.ps1')
    $createuserscriptpath = $basescriptPath + '\AD_Users_Create\'
    do{
      createuser -Domain $Domain -OUList $ousAll -ScriptDir $createuserscriptpath
        Write-Progress -Activity "Random Stuff into A domain - Creating $NumOfUsers Users" -Status "Progress:" -PercentComplete ($x/$NumOfUsers*100)
    $x++
    }while($x -lt $NumOfUsers)
    $AllUsers = Get-aduser -Filter *
    write-host "Creating Groups on Domain" -ForegroundColor Green
    $NumOfGroups = $groupSize
    $X=1
    Write-Progress -Activity "Random Stuff into A domain - Creating $NumOfGroups Groups" -Status "Progress:" -PercentComplete ($i/$totalscripts*100)
    $I++
    .($basescriptPath + '\AD_Groups_Create\CreateGroups.ps1')
    
    do{
        Creategroup
        Write-Progress -Activity "Random Stuff into A domain - Creating $NumOfGroups Groups" -Status "Progress:" -PercentComplete ($x/$NumOfGroups*100)
    $x++
    }while($x -lt $NumOfGroups)
    $Grouplist = Get-ADGroup -Filter { GroupCategory -eq "Security" -and GroupScope -eq "Global"  } -Properties isCriticalSystemObject
    $LocalGroupList =  Get-ADGroup -Filter { GroupScope -eq "domainlocal"  } -Properties isCriticalSystemObject
    write-host "Creating Computers on Domain" -ForegroundColor Green
    $NumOfComps = $compNum
    $X=1
    Write-Progress -Activity "Random Stuff into A domain - Creating Computers" -Status "Progress:" -PercentComplete ($i/$totalscripts*100)
    .($basescriptPath + '\AD_Computers_Create\CreateComputers.ps1')
    $I++
    do{
        Write-Progress -Activity "Random Stuff into A domain - Creating $NumOfComps computers" -Status "Progress:" -PercentComplete ($x/$NumOfComps*100)
        createcomputer
    $x++
    }while($x -lt $NumOfComps)
    $Complist = get-adcomputer -filter *
    
    $I++
    write-host "Creating Permissions on Domain" -ForegroundColor Green
    Write-Progress -Activity "Random Stuff into A domain - Creating Random Permissions" -Status "Progress:" -PercentComplete ($i/$totalscripts*100)
    .($basescriptPath + '\AD_Permissions_Randomizer\GenerateRandomPermissions.ps1')
    
    
    $I++
    write-host "Nesting objects into groups on Domain" -ForegroundColor Green
    .($basescriptPath + '\AD_Groups_Create\AddRandomToGroups.ps1')
    Write-Progress -Activity "Random Stuff into A domain - Adding Stuff to Stuff and Things" -Status "Progress:" -PercentComplete ($i/$totalscripts*100)
    AddRandomToGroups -Domain $Domain -Userlist $AllUsers -GroupList $Grouplist -LocalGroupList $LocalGroupList -complist $Complist
    
}
