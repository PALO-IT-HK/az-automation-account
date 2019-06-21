param (
  [Parameter(Mandatory=$true)]
  [string]
  $VMAction
)

$connectionName = "AzureRunAsConnection"
try
{
  # Get the connection "AzureRunAsConnection "
  $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName

  "Logging in to Azure..."
  Add-AzureRmAccount `
    -ServicePrincipal `
    -TenantId $servicePrincipalConnection.TenantId `
    -ApplicationId $servicePrincipalConnection.ApplicationId `
    -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint
}
catch {
  if (!$servicePrincipalConnection)
  {
    $ErrorMessage = "Connection $connectionName not found."
    throw $ErrorMessage
  } else{
    Write-Error -Message $_.Exception
    throw $_.Exception
  }
}

$vms = Get-AzureRmVm -ResourceGroup TrainingResource

foreach ($vm in $vms)
{
  if ($VMAction -eq "Start") {
    Write-Output ("Starting " + $vm.Name + " VM")
    $vm | Start-AzureRmVm
  }
  if ($VMAction -eq "Stop") {
    Write-Output ("Stopping " + $vm.Name + " VM")
    $vm | Stop-AzureRmVm -Force
  }
}
