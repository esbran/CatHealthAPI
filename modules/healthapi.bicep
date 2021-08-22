targetScope = 'resourceGroup'

param name string
param storageAccountName string
param myTags object
param eventHubName string
param consumerGroup string
param fullyQualifiedEventHubNamespace string
param eventhubDetails object
param authorityUrl string = '${environment().authentication.loginEndpoint}${subscription().tenantId}'
param audienceUrl string = 'https//${name}healthapi-${name}healthapi-fhir.fhir.azurehealthcareapis.com'

resource healthapi 'Microsoft.HealthcareApis/workspaces@2021-06-01-preview' = {
  name: '${name}healthapi'
  location: resourceGroup().location
  tags: myTags

  resource healthApiFihr 'fhirservices@2021-06-01-preview' = {
    name: '${name}healthapi-fhir'
    kind: 'fhir-R4'
    location: resourceGroup().location
    properties: {
      //accessPolicies: 
      authenticationConfiguration: {
          authority: authorityUrl
          audience: audienceUrl
          smartProxyEnabled: false
      }
      corsConfiguration: {
        allowCredentials: false
        headers: [
          '*'
        ]
        maxAge: 1440
        methods: [
          'DELETE'
          'GET'
          'OPTIONS'
          'PATCH'
          'POST'
          'PUT'
        ]
        origins: [
          'https://localhost:6001'
        ]
      }
      exportConfiguration: {
        storageAccountName: storageAccountName
      }
    }
    
  }

  resource healthApiDicom 'dicomservices@2021-06-01-preview' = {
    name: '${name}healtapi-dicom'
    location: resourceGroup().location
  }

  resource healtApiIot 'iotconnectors@2021-06-01-preview' = {
    name: '${name}healtapi-iot'
    location: resourceGroup().location
    properties: {
      ingestionEndpointConfiguration:{
        eventHubName: eventHubName
        consumerGroup: consumerGroup
        fullyQualifiedEventHubNamespace: fullyQualifiedEventHubNamespace
      }
    }
  }
}


output healtapiout string = '${name}healtapi'





