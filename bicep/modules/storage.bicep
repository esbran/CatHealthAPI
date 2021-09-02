targetScope = 'resourceGroup'

param name string
param myTags object

resource healthstorage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: '${name}healthstorage'
  location: resourceGroup().location
  kind: 'StorageV2'
  tags: myTags
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    isHnsEnabled: true
  }
}

output storageAccountName string = healthstorage.name
