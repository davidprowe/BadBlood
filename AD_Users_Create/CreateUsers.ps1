Function CreateUser{

$setDC = (Get-ADDomain).pdcemulator

function Get-ScriptDirectory {
    Split-Path -Parent $PSCommandPath
}
$scriptPath = Get-ScriptDirectory

function New-SWRandomPassword {
    <#
    .Synopsis
       Generates one or more complex passwords designed to fulfill the requirements for Active Directory
    .DESCRIPTION
       Generates one or more complex passwords designed to fulfill the requirements for Active Directory
    .EXAMPLE
       New-SWRandomPassword
       C&3SX6Kn

       Will generate one password with a length between 8  and 12 chars.
    .EXAMPLE
       New-SWRandomPassword -MinPasswordLength 8 -MaxPasswordLength 12 -Count 4
       7d&5cnaB
       !Bh776T"Fw
       9"C"RxKcY
       %mtM7#9LQ9h

       Will generate four passwords, each with a length of between 8 and 12 chars.
    .EXAMPLE
       New-SWRandomPassword -InputStrings abc, ABC, 123 -PasswordLength 4
       3ABa

       Generates a password with a length of 4 containing atleast one char from each InputString
    .EXAMPLE
       New-SWRandomPassword -InputStrings abc, ABC, 123 -PasswordLength 4 -FirstChar abcdefghijkmnpqrstuvwxyzABCEFGHJKLMNPQRSTUVWXYZ
       3ABa

       Generates a password with a length of 4 containing atleast one char from each InputString that will start with a letter from 
       the string specified with the parameter FirstChar
    .OUTPUTS
       [String]
    .NOTES
       Written by Simon WÃ¥hlin, blog.simonw.se
       I take no responsibility for any issues caused by this script.
    .FUNCTIONALITY
       Generates random passwords
    .LINK
       http://blog.simonw.se/powershell-generating-random-password-for-active-directory/
   
    #>
    [CmdletBinding(DefaultParameterSetName='FixedLength',ConfirmImpact='None')]
    [OutputType([String])]
    Param
    (
        # Specifies minimum password length
        [Parameter(Mandatory=$false,
                   ParameterSetName='RandomLength')]
        [ValidateScript({$_ -gt 0})]
        [Alias('Min')] 
        [int]$MinPasswordLength = 12,
        
        # Specifies maximum password length
        [Parameter(Mandatory=$false,
                   ParameterSetName='RandomLength')]
        [ValidateScript({
                if($_ -ge $MinPasswordLength){$true}
                else{Throw 'Max value cannot be lesser than min value.'}})]
        [Alias('Max')]
        [int]$MaxPasswordLength = 20,

        # Specifies a fixed password length
        [Parameter(Mandatory=$false,
                   ParameterSetName='FixedLength')]
        [ValidateRange(1,2147483647)]
        [int]$PasswordLength = 8,
        
        # Specifies an array of strings containing charactergroups from which the password will be generated.
        # At least one char from each group (string) will be used.
        [String[]]$InputStrings = @('abcdefghijkmnpqrstuvwxyz', 'ABCEFGHJKLMNPQRSTUVWXYZ', '23456789', '!#%&'),

        # Specifies a string containing a character group from which the first character in the password will be generated.
        # Useful for systems which requires first char in password to be alphabetic.
        [String] $FirstChar,
        
        # Specifies number of passwords to generate.
        [ValidateRange(1,2147483647)]
        [int]$Count = 1
    )
    Begin {
        Function Get-Seed{
            # Generate a seed for randomization
            $RandomBytes = New-Object -TypeName 'System.Byte[]' 4
            $Random = New-Object -TypeName 'System.Security.Cryptography.RNGCryptoServiceProvider'
            $Random.GetBytes($RandomBytes)
            [BitConverter]::ToUInt32($RandomBytes, 0)
        }
    }
    Process {
        For($iteration = 1;$iteration -le $Count; $iteration++){
            $Password = @{}
            # Create char arrays containing groups of possible chars
            [char[][]]$CharGroups = $InputStrings

            # Create char array containing all chars
            $AllChars = $CharGroups | ForEach-Object {[Char[]]$_}

            # Set password length
            if($PSCmdlet.ParameterSetName -eq 'RandomLength')
            {
                if($MinPasswordLength -eq $MaxPasswordLength) {
                    # If password length is set, use set length
                    $PasswordLength = $MinPasswordLength
                }
                else {
                    # Otherwise randomize password length
                    $PasswordLength = ((Get-Seed) % ($MaxPasswordLength + 1 - $MinPasswordLength)) + $MinPasswordLength
                }
            }

            # If FirstChar is defined, randomize first char in password from that string.
            if($PSBoundParameters.ContainsKey('FirstChar')){
                $Password.Add(0,$FirstChar[((Get-Seed) % $FirstChar.Length)])
            }
            # Randomize one char from each group
            Foreach($Group in $CharGroups) {
                if($Password.Count -lt $PasswordLength) {
                    $Index = Get-Seed
                    While ($Password.ContainsKey($Index)){
                        $Index = Get-Seed                        
                    }
                    $Password.Add($Index,$Group[((Get-Seed) % $Group.Count)])
                }
            }

            # Fill out with chars from $AllChars
            for($i=$Password.Count;$i -lt $PasswordLength;$i++) {
                $Index = Get-Seed
                While ($Password.ContainsKey($Index)){
                    $Index = Get-Seed                        
                }
                $Password.Add($Index,$AllChars[((Get-Seed) % $AllChars.Count)])
            }
            Write-Output -InputObject $(-join ($Password.GetEnumerator() | Sort-Object -Property Name | Select-Object -ExpandProperty Value))
        }
    }
}

    
#get owner all parameters and store as variable to call upon later
        $userlist = get-adobject -Filter {objectclass -eq 'user'} -ResultSetSize 2500 -Server $setdc|Where-object -Property objectclass -eq user
        $ownerinfo = get-random $userlist
                $adminID = (get-random $userlist).samaccountname
    

#=======================================================================

$OUsAll = get-adobject -Filter {objectclass -eq 'organizationalunit'} -ResultSetSize 300
#will work on adding things to containers later $ousall += get-adobject -Filter {objectclass -eq 'container'} -ResultSetSize 300|where-object -Property objectclass -eq 'container'|where-object -Property distinguishedname -notlike "*}*"|where-object -Property distinguishedname -notlike  "*DomainUpdates*"

                    $ouLocation = (Get-Random $OUsAll).distinguishedname



$accountType = 1..100|get-random 
if($accountType -le 10){ # X percent chance of being a service account
#service
$nameSuffix = "SA"
$description = 'Created with secframe.com/badblood.'
do {
    $checkAcct= $null
    $name = ""+ (Get-Random -Minimum 100000 -Maximum 999999) + "$nameSuffix"
        if ($Dispname -eq ''){$Dispname = $name}
        else{}
    try{$checkAcct = get-aduser $name}
    catch{}
    
    }
    while($checkAcct -ne $null)
}else{
    $surname = get-content($scriptpath + '\Names\familynames-usa-top1000.txt')|get-random
$genderpreference = 0,1|get-random
if ($genderpreference -eq 0){$givenname = get-content($scriptpath + '\Names\femalenames-usa-top1000.txt')|get-random}else{$givenname = get-content($scriptpath + '\Names\malenames-usa-top1000.txt')|get-random}
$name = $givenname+"_"+$surname
}

    $departmentnumber = [convert]::ToInt32('9999999') 
    
    
#Need to figure out how to do the L attribute
$description = 'Created with secframe.com/badblood.'
$pwd = New-SWRandomPassword -MinPasswordLength 22 -MaxPasswordLength 25
#======================================================================
#if RA account - create account disabled

    try{new-aduser -server $setdc  -Description $Description -DisplayName $name -name $name -SamAccountName $name -Surname $name -Enabled $true -Path $ouLocation -AccountPassword (ConvertTo-SecureString ($pwd) -AsPlainText -force)}
            catch {$pwd = New-SWRandomPassword -MinPasswordLength 22 -MaxPasswordLength 25
                try{new-aduser -server $setdc  -Description $Description -DisplayName $name -name $name -SamAccountName $name -Surname $name -Enabled $true -Path $OUlocation -AccountPassword (ConvertTo-SecureString ($pwd) -AsPlainText -force)}
                catch{$pwd = New-SWRandomPassword -MinPasswordLength 22 -MaxPasswordLength 25
                      try{new-aduser -server $setdc -Description $Description -DisplayName $name -name $name -SamAccountName $name -Surname $name -Enabled $true -Path $OUlocation -AccountPassword (ConvertTo-SecureString ($pwd) -AsPlainText -force)}
                      catch{
                          #just dont make it
                      }
                     }
                }
    

$pwd = ''

#===============================
#SET ATTRIBUTES - no additional attributes set at this time besides UPN
#Todo: Set SPN for kerberoasting.  Example attribute edit is in createcomputers.ps1
#===============================

$dnsroot = (get-addomain).dnsroot
$upn = $name + '@' + $dnsroot
try{Set-ADUser -Identity $name -UserPrincipalName "$upn" }
catch{}

################################
#End Create User Objects
################################

}


