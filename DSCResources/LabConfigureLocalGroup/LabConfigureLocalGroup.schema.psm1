#requires -Version 4.0
<#
    .Synopsis
    ArdyLab DSC Resource to Configure a LocalGroup on a node.

    .Description
    blah, blah
    
    .TODO
    Add Error Checking and Verbose/Debug output
#>

Configuration LabConfigureLocalGroup
{
  param             
  (   
    [Parameter(Mandatory)]             
    [string]
    $GroupName,

    [Parameter()]             
    [string]
    $DomainName = '\',

    [Parameter()]             
    [psobject]
    $MembersToInclude,

    [Parameter(Mandatory)]             
    [pscredential]
    $Credential
  )

  Import-DscResource -ModuleName PSDesiredStateConfiguration

  # Populate Local Groups with custom User/Groups
  # Add required entries to the array $LocalAdminGroupMembers
        
  $LocalAdminGroupMembers = @()

  foreach ($principal in $MembersToInclude)
  {
    $LocalAdminGroupMembers += "$(($DomainName -split '\.')[0])\$($principal)"
  } # END - foreach $principal        

  if ($LocalAdminGroupMembers)
  {
    Group $GroupName
    {
      GroupName = 'Administrators'
      MembersToInclude = $LocalAdminGroupMembers
      Ensure = 'present'
      Credential = $Credential
    }
  }
}