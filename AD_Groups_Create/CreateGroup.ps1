Function CreateGroup {
    <#
        .SYNOPSIS
            Creates a Group in an active directory environment based on random data
        
        .DESCRIPTION
            Starting with the root container this tool randomly places users in the domain.
        
        .PARAMETER Domain
            The stored value of get-addomain is used for this.  It is used to call the PDC and other items in the domain
        
        .PARAMETER OUList
            The stored value of get-adorganizationalunit -filter *.  This is used to place users in random locations.

        .PARAMETER UserList
            The stored value of get-aduser -filter *.  This is used to place make random users owners/managers of groups.
        
        .PARAMETER ScriptDir
            The location of the script.  Pulling this into a parameter to attempt to speed up processing.
        
        .EXAMPLE
            
     
        
        .NOTES
            
            
            Unless required by applicable law or agreed to in writing, software
            distributed under the License is distributed on an "AS IS" BASIS,
            WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
            See the License for the specific language governing permissions and
            limitations under the License.
            
            Author's blog: https://www.secframe.com
    
        
    #>
    [CmdletBinding()]
    
    param
    (
        [Parameter(Mandatory = $false,
            Position = 1,
            HelpMessage = 'Supply a result from get-addomain')]
            [Object[]]$Domain,
        [Parameter(Mandatory = $false,
            Position = 2,
            HelpMessage = 'Supply a result from get-adorganizationalunit -filter *')]
            [Object[]]$OUList,
        [Parameter(Mandatory = $false,
            Position = 3,
            HelpMessage = 'Supply a result from get-aduser -filter *')]
            [Object[]]$UserList,
        [Parameter(Mandatory = $false,
                Position = 4,
                HelpMessage = 'Supply the script directory for where this script is stored')]
            [string]$ScriptDir
    )
    
        if(!$PSBoundParameters.ContainsKey('Domain')){
            if($args[0]){$setDC = $args[0].pdcemulator}
            else{$setDC = (Get-ADDomain).pdcemulator}
        }else {$setDC = $Domain.pdcemulator}
        if (!$PSBoundParameters.ContainsKey('OUList')){
            if($args[1]){
                $OUsAll = $args[1]
            }
            else{
                $OUsAll = get-adobject -Filter {objectclass -eq 'organizationalunit'} -ResultSetSize 300
            }
        }else {
            $OUsAll = $OUList
        }
        if (!$PSBoundParameters.ContainsKey('UserList')){
            if($args[1]){
                $UserList = $args[2]
            }
            else{
                $UserList = get-aduser -ResultSetSize 2500 -Server $setDC -Filter * 
            }
        }else {
            $UserList = $UserList
        }
        if (!$PSBoundParameters.ContainsKey('ScriptDir')){
            
            if($args[2]){

                $groupscriptPath = $args[2]}
            else{
                    $groupscriptPath = "$((Get-Location).path)\AD_Groups_Create\"
            }
            
        }else{
            $groupscriptPath = $ScriptDir
        }
        
        $ownerinfo = get-random $userlist
        $Description = "User Group Created by Badblood github.com/davidprowe/badblood"
        
        <#
        ================================
        OU LOCATION
        ================================
        $OUsAll = get-adobject -Filter {objectclass -eq 'organizationalunit'} -ResultSetSize 300
        will work on adding objects to containers later $ousall += get-adobject -Filter {objectclass -eq 'container'} -ResultSetSize 300|where-object -Property objectclass -eq 'container'|where-object -Property distinguishedname -notlike "*}*"|where-object -Property distinguishedname -notlike  "*DomainUpdates*"

        #>
        $ouLocation = (get-random $OUsAll).distinguishedname

        $Groupnameprefix = ''
        $Groupnameprefix = ($ownerinfo.samaccountname).substring(0,2) 
        $application = try{(get-content($groupscriptPath + '\hotmail.txt')|get-random).substring(0,9)} catch{(get-content($groupscriptPath + '\hotmail.txt')|get-random).substring(0,3) }
        $functionint = 1..100|Get-random  
        if($functionint -le 25){$function = 'admingroup'}else{$function = 'distlist'}              
        $GroupNameFull = $Groupnameprefix + '-'+$Application+ '-'+$Function
        <#
         Append name if dupe /
        #>
        $i = 1
        $checkAcct = $null
        do {
            try{$checkAcct = get-adgroup $GroupNameFull}
            catch{
                $GroupNameFull = $GroupNameFull + $i
                
            }
            $i++
        }while($null -ne $checkAcct)   

        try{New-ADGroup -Server $setdc -Description $Description -Name $GroupNameFull -Path $ouLocation -GroupCategory Security -GroupScope Global -ManagedBy $ownerinfo.distinguishedname}
        catch{}
        
}