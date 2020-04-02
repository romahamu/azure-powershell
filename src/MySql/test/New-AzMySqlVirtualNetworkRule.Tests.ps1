$loadEnvPath = Join-Path $PSScriptRoot 'loadEnv.ps1'
if (-Not (Test-Path -Path $loadEnvPath)) {
    $loadEnvPath = Join-Path $PSScriptRoot '..\loadEnv.ps1'
}
. ($loadEnvPath)
$TestRecordingFile = Join-Path $PSScriptRoot 'New-AzMySqlVirtualNetworkRule.Recording.json'
$currentPath = $PSScriptRoot
while(-not $mockingPath) {
    $mockingPath = Get-ChildItem -Path $currentPath -Recurse -Include 'HttpPipelineMocking.ps1' -File
    $currentPath = Split-Path -Path $currentPath -Parent
}
. ($mockingPath | Select-Object -First 1).FullName

Describe 'New-AzMySqlVirtualNetworkRule' {
    It 'CreateExpanded' -skip {
        $ID = "/subscriptions/$($env.SubscriptionId)/resourceGroups/$($env.resourceGroup)/providers/Microsoft.Network/virtualNetworks/MySqlVNet/subnets/MysqlSubnet1"
        $vnetRule = New-AzMySqlVirtualNetworkRule -Name $env.VNetName -ResourceGroupName $env.resourceGroup -ServerName $env.serverName -VirtualNetworkSubnetId $ID
        $vnetRule.Count | Should -Be 1
        Remove-AzMySqlVirtualNetworkRule -Name $env.VNetName -ResourceGroupName $env.resourceGroup-ServerName $env.serverName 
    }
}
