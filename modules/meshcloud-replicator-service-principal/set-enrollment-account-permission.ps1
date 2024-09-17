param (
    [Parameter(Mandatory = $true), HelpMessage="The object ID of the replicator enterprise application"]
    [string]
    $principalId

    [Parameter(Mandatory = $true), HelpMessage="Your AAD tenant id"]
    [string]
    $aadTenantId

    [Parameter(Mandatory = $true), HelpMessage="You can find the billing account id in the Azure portal on the Cost Management + Billing overview page."]
    [Int]
    $billingAccountId


    [Parameter(Mandatory = $true), HelpMessage="You can find the enrollment account id in the Azure portal on the Detail page of your enrollment account."]
    [Int]
    $enrollmentAccountId
)

# Build the request
$token = (Get-AzAccessToken -ResourceUrl 'https://management.azure.com').Token
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/json")
$headers.Add("Authorization","Bearer $token")
$billingRoleAssignmentName = (New-Guid).Guid

$url = "https://management.azure.com/providers/Microsoft.Billing/billingAccounts/$billingAccountId/enrollmentAccounts/$enrollmentAccountId/billingRoleAssignments/$billingRoleAssignmentName`?api-version=2019-10-01-preview"

# Subscription Creator. See https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/assign-roles-azure-service-principals#permissions-that-can-be-assigned-to-the-spn
$roleDefinitionId = "/providers/Microsoft.Billing/billingAccounts/$billingAccountId/enrollmentAccounts/$enrollmentAccountId/billingRoleDefinitions/a0bcee42-bf30-4d1b-926a-48d21664ef71"

$body = "{
`"properties`": {
  `"principalId`": `"$principalId`",
  `"principalTenantId`": `"$aadTenantId`",
  `"roleDefinitionId`": `"$roleDefinitionId`"}`n}"

# Send request
Invoke-RestMethod $url -Method 'Put' -Headers $headers -Body $body | Format-List

# Check that the creation was successfull
Invoke-RestMethod $url -Method 'Get' -Headers $headers | Format-List
