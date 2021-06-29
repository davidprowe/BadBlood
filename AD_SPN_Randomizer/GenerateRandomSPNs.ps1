Function CreateRandomSPNs{

    <#
        .SYNOPSIS
            Creates random SPNs based on combinations of users and computers
        
        .DESCRIPTION
            Creates random SPNs based on combinations of users and computers
        
        .PARAMETER Count
            The number of random SPNs to create
        
        .EXAMPLE
            
     
        
        .NOTES
            
            
            Unless required by applicable law or agreed to in writing, software
            distributed under the License is distributed on an "AS IS" BASIS,
            WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
            See the License for the specific language governing permissions and
            limitations under the License.
            
            Created by www.github.com/sussurro
    
        
    #>
    [CmdletBinding()]
    
    param
    (
        [Parameter(Mandatory = $false,
            Position = 1,
            HelpMessage = 'supply a count for the number of spns to create')]
            [int32]$SPNCount = 50
    )
    
    $services = ("https","ftp","CIFS","kafka","MSSQL","POP3")
    $computers = Get-ADComputer -Filter * 
    $users = Get-ADUser -Filter *
    
    $i = 0
    Do {
        $computer = $computers | Get-Random
        $user = $users | Get-Random
        $service = $services | get-Random
        $cn = $computer.Name
        $spn = "$service/$cn"
        
        Try { 
        	$user | Set-ADUser -ServicePrincipalNames @{Add=$spn} -ErrorAction Stop
        }Catch { $i--}

        $i++
    } While($i -lt $SPNCount)
}
    
