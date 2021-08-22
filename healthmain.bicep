targetScope = 'subscription'

param name string = 'cat'
param location string = 'westeurope'

var myTags = {
  Owner: 'Espen'
  Project: 'Healthcare'
  Name: name
}

resource healthResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: '${name}health'
  location: location
  tags: myTags
  properties: {}
}

module storage 'modules/storage.bicep' = {
  name: 'storage'
  scope: healthResourceGroup
  params: {
    name: name
    myTags: myTags
  }
}

module healthapi 'modules/healthapi.bicep' = {
  scope: healthResourceGroup
  name: 'healthapi'
  params: {
    name: name
    myTags: myTags
    storageAccountName: storage.outputs.storageAccountName
    eventHubName: eventHub.outputs.eventHubName
    consumerGroup: eventHub.outputs.consumerGroup
    fullyQualifiedEventHubNamespace: eventHub.outputs.fullyQualifiedEventHubNamespace
    eventhubDetails: eventHub.outputs.eventhubdetails
  }
}

module eventHub 'modules/eventhub.bicep' = {
  scope: healthResourceGroup
  name: 'eventhub'
  params: {
    name: name
    myTags: myTags
  }
}
