$fhirservice = "https://esp1-esp1fhir.fhir.azurehealthcareapis.com"
$token = (Get-AzAccessToken -ResourceUrl $fhirservice).token
$file = "C:\Users\espen\OneDrive - Microsoft\Code\CATHealth\CatHealthAPI\sampledata\fhir\simplepatient.json"
#$file = "sampledata\fhir\Adolph80_Runolfsson901_89b38456-3ee1-40cb-a541-2918bda7cc84.json"
$filecontent =  Get-Content -Raw $file
$fhiruri = 'https://esp1-esp1fhir.fhir.azurehealthcareapis.com/Patient'

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Bearer $($token)")
$headers.Add("Content-Type", "application/json")

$FhirGetPatient = Invoke-RestMethod 'https://esp1-esp1fhir.fhir.azurehealthcareapis.com/' `
    -Method 'POST' `
    -Headers $headers `
    -Body $filecontent
Write-Host $FhirGetPatient | ConvertTo-Json