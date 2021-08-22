
#Remove-AzResourceGroup -Name tempHealth 
#New-AzResourceGroup -Name tempHealth -Location westeurope

#New-AzResourceGroupDeployment -ResourceGroupName tempHealth -TemplateFile ./health.bicep
#New-AzResourceGroupDeployment -ResourceGroupName tempHealth -TemplateFile ./testing.bicep

New-AzDeployment -Location "westeurope" -TemplateFile "./healthmain.bicep" #-TemplateParameterFile "./health.parameters.json" -TemplateVersion "2.1"