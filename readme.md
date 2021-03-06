# MC4H Implementation

Initiate the deployment wizard using this button:
[![Deploy To Azure](https://docs.microsoft.com/en-us/azure/templates/media/deploy-to-azure.svg)](https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fesbran%2FCatHealthAPI%2Fmain%2Fmc4h%2Fmc4hAzure.json/uiFormDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2Fesbran%2FCatHealthAPI%2Fmain%2Fmc4h%2Fmc4h.json)

## Post deployment 
Get the FHIR endpoint:
![FHIR screenshot of the endpoint](doc/img/fhir_url_screenshot.jpg "FHIR Endpoint")

###Validate the deployment: 
Ensure you are connected to the correct tenant and subscription
```powershell
Connect-AzAccount -Tenant "<<your_tenant_id>>" -Subscription "<<your_subscription_id>>"
```
$fhirservice is the endpoint you copied in the previous step.
```powershell
$fhirservice = 'https://<<your_healtcare_api_service>>'
$token = (Get-AzAccessToken -ResourceUrl $fhirservice).token

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Bearer $($token)")
$headers.Add("Content-Type", "application/json")

$FhirGetMalePatients = Invoke-RestMethod "$fhirservice/Patient?gender:not=female" `
    -Method 'GET' `
    -Headers $headers 
Write-Host $FhirGetPatient
```

### Sample patient data
To simplify dowloading sample data and posting it to the API you can either clone this repo and run download.ps1 or you can run edit and paste this:

```powershell
$token = (Get-AzAccessToken -ResourceUrl $fhirservice).token

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Bearer $($token)")
$headers.Add("Content-Type", "application/json")
function DownloadFilesFromRepo {
    Param(
        [string]$Owner,
        [string]$Repository,
        [string]$Path,
        [string]$fhirservice
        )
    
        $baseUri = "https://api.github.com/"
        $args = "repos/$Owner/$Repository/contents/$Path"
        $wr = Invoke-WebRequest -Uri $($baseuri+$args)
        $objects = $wr.Content | ConvertFrom-Json
        $files = $objects | where {$_.type -eq "file"} | Select -exp download_url
        $directories = $objects | where {$_.type -eq "dir"}
        
        $directories | ForEach-Object { 
            DownloadFilesFromRepo -Owner $Owner -Repository $Repository -Path $_.path -DestinationPath $($DestinationPath+$_.name)
        }

        foreach ($file in $files[0]) {
            $dlfile = Invoke-WebRequest -Uri $file
            try {

                $FhirGetPatient = Invoke-RestMethod "$fhirservice/" `
                -Method 'POST' `
                -Headers $headers `
                -Body $dlfile  

                Write-Host $file
            } catch {
                throw "Unable to download '$($file)' Patient: '$($FhirGetPatient)'"
            }
        }
    }

    DownloadFilesFromRepo -Owner 'esbran' -Repository 'CatHealthAPI' -Path 'sampledata/fhir/' -fhirservice 'https://{<<your_fhir_service>>}.azurehealthcareapis.com'
```
<mark>Remember to replace <<your_fhir_service>> in the last line before running the function DownloadFilesFromRepo.</mark>

### Search the patients

Exsample of a search that returns all non-femail patients:
```powershell
$FhirGetMalePatients = Invoke-RestMethod "$fhirservice/Patient?gender:not=female" `
    -Method 'GET' `
    -Headers $headers 
Write-Host $FhirGetPatient
```
Other examples can be found here: [FHIR Search](https://github.com/esbran/CatHealthAPI/blob/5b85cdefeb52c58347f58555da9a2c6c325dd1ff/fhirget.ps1)

> ### Known issues
> There are a few known issues:
> - Existing storage account and existing workspace is currently not mapped
> - Container for storage account must be created post deployment (will be fixed shortly)
> - FHIR sync agent is coming shortly
> - FHIR proxy is coming shortly
