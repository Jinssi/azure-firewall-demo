param parentName string

resource parentFirewall 'Microsoft.Network/firewallPolicies@2021-05-01' existing = {
  name: parentName
}

resource vnetRuleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2020-11-01' = {
  name: 'On-premises'
  parent: parentFirewall
  properties: {
    priority: 300
    ruleCollections: [
      {
        name: 'Allow-On-premises-To-VNET-Network-Rules'
        priority: 301
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'Spoke001 to on-premises'
            description: 'Allow spoke001 to connect to on-premises network'
            ipProtocols: [
              'Any'
            ]
            sourceAddresses: [
              '10.1.0.0/22'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '192.168.0.0/24'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '*'
            ]
          }
        ]
      }
      {
        name: 'Allow-VNET-To-On-premises-Application-Rules'
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        priority: 302
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'On-premises to spoke001 using http'
            description: 'Allow on-premises network to connect to spoke001 using http on port 80'
            sourceAddresses: [
              '192.168.0.0/24'
            ]
            protocols: [
              {
                port: 80
                protocolType: 'Http'
              }
            ]
            destinationAddresses: [
              '10.1.0.0/22'
            ]
          }
        ]
      }
    ]
  }
}
