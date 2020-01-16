$dom = get-addomain
$setdc = $dom.pdcemulator
cd ad:
$dn = $dom.distinguishedname
$AllOUs = Get-ADOrganizationalUnit -Filter *
$allUsers = get-aduser -Filter *
$allGroups = get-adgroup -f * -ResultPageSize 2500
$allcomps = Get-ADComputer -f *
<#Pick X number of random users#>
$UsersInGroupCount = [math]::Round($allusers.count * .8) #need to round to int. need to check this works
$GroupsInGroupCount = [math]::Round($allGroups.count * .2)
$CompsInGroupCount = [math]::Round($AllComputers.count * .1)

#get user list

$AddUserstoGroups = get-random -count $UsersInGroupCount -InputObject $allUsers

Foreach ($user in $AddUserstoGroups){
    #get how many groups
    $num = 1..15|Get-Random
    $n = 0
    do{
        $randogroup = $allgroups|Get-Random
        #add to group
        try{Add-ADGroupMember -Identity $randogroup -Members $user}
        catch{}
        $n++
    }while($n -le $num)
}


$AddGroupstoGroups = get-random -count $GroupsInGroupCount -InputObject $allGroups

Foreach ($group in $AddGroupstoGroups){
    #get how many groups
    $num = 1..10|Get-Random
    $n = 0
    do{
        $randogroup = $allgroups|Get-Random
        #add to group
        try{Add-ADGroupMember -Identity $randogroup -Members $group}
        catch{}
        $n++
    }while($n -le $num)
}

$addcompstoGroups = @()
$addcompstogroups = get-random -count $compsInGroupCount -InputObject $allcomps


Foreach ($comp in $addcompstogroups){
    #get how many groups
    $num = 1..5|Get-Random
    $n = 0
    do{
        $randogroup = $allgroups|Get-Random
        #add to group
        try{Add-ADGroupMember -Identity $randogroup -Members $comp}
        catch{}
        $n++
    }while($n -le $num)
}


