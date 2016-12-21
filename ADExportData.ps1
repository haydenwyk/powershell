##  AD Validation Script ##
## 2016, Tassal ## 


## CHANGE NOTES ## 
#
#
# V1.3 # 
# Changed Array addition to Object based method to increase speed of script 

## FUTURE UPDATES ##
# Ensure Title and Description are the same 
#
#




## *** START SCRIPT *** ## 


# Initialise an empty Variable 
$SingleOU = "" 
$UserOUs = New-Object System.Collections.ArrayList
$Users = New-Object  System.Collections.ArrayList

# Get a list of all OU's within our Domain 
$AllOUs =@(Get-ADOrganizationalUnit -Filter * -Properties DistinguishedName | select -ExpandProperty DistinguishedName) 

# Loop through and grab only the OU's with USERS OU=USERS in their name (as we only care about Users) 

    ForEach ($SingleOU in $AllOUs) {

        If ($SingleOU -like "OU=Users,*") {
         
                $UserOUs.Add($SingleOU) | Out-Null 

                }$
            }
           
# Search each OU for missing data 

    ForEach ($OU in $UserOUs) { 

    Write-Host "*********NOW SEARCHING: $Ou*********"  
        
        # Get a list of users to search through using GET-ADUSER 
        $Users += @(get-aduser -SearchBase $OU -Filter * -Properties SamAccountName | select -expand  SamAccountName) 

        # $res = Get-ADUser -Filter "*" | where {$exclude -notcontains $_.DistinguishedName}
        }
            
            ForEach ($User in $Users) { 

            get-aduser $User -Properties DisplayName,Description,Department,Title,Manager | 
            select  DisplayName,Description,Department,Title,@{label='Manager';expression={$_.manager -replace '^CN=|,.*$'}} | 
            Export-Csv -Path "C:\reports\Reports.csv" -NoTypeInformation -Append
            

}
                                
    #}

## *** END SCRIPT *** ## 