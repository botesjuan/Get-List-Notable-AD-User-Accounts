$searchdate = "2019-05-01" #yyyy-MM-dd format  
$ADtopDN = "DC=top,DC=corp,DC=xo,DC=ya"  #  Active Directory search DN object top of domain
  
$PwdLastSetDate = $([datetime]::parseexact($searchdate,'yyyy-MM-dd',$null)).ToFileTime()  
write-verbose "Finding users whose passwords have not changed since $([datetime]::fromfiletimeUTC($PwdLastSetDate))"  
  
$NoPassChangeData = Get-ADUser -filter { Enabled -eq $True } –Properties pwdLastSet -ADtopDN $ADtopDN |
    where { $_.pwdLastSet -lt $PwdLastSetDate -and $_.pwdLastSet -ne 0 } |
    Select-Object name,sAmAccountName,@{Name="PasswordLastSet";Expression={[datetime]::FromFileTimeUTC($_.pwdLastSet) } }

$NoPassChangeData.count
$NoPassChangeData | Export-Csv -NoTypeInformation -Path "D:\output\NoPassChangeData.csv"
