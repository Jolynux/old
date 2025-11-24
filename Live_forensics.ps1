#Netstat -aon
$NetstatList = Get-NetTCPConnection | Select-Object OwningProcess, `
                                                    @{l="ProcessName";e={(Get-Process -Id $_.OwningProcess).ProcessName}}, `
                                                    LocalAddress, `
                                                    LocalPort, `
                                                    State, `
                                                    RemoteAddress; `
                                                    RemotePort

$NetstatList | Export-CSV -Path "C:\Users\$($env:USERNAME)\Desktop\Netstat.csv" -Force -NoTypeInformation -Delimiter ";"

#Cartes Réseau (ipconfig)
$NICList = Get-NetAdapter | Select-Object ifDesc, `
                                        MacAddress, `
                                        AdminStatus, `
                                        Status, `
                                        @{l="IPAddresses";e={($_ | Get-NetIPAddress -AddressFamily IPv4).IPAddress}}, `
                                        @{l="CIDR";e={($_ | Get-NetIPAddress -AddressFamily IPv4).PrefixLength}}, `
                                        @{l="Origin";e={($_ | Get-NetIPAddress -AddressFamily IPv4).PrefixOrigin}}

$NICList | Export-CSV -Path "C:\Users\$($env:USERNAME)\Desktop\ipconfig.csv" -Force -NoTypeInformation -Delimiter ";"


#Table ARP
$ARP = Get-NetNeighbor -AddressFamily IPv4 | Select-Object @{l="ifDesc";e={(Get-NetAdapter -InterfaceIndex $_.ifIndex).ifDesc}}, `
                                                            IPAddress, `
                                                            LinkLayerAddress, `
                                                            State

$ARP | Export-CSV -Path "C:\Users\$($env:USERNAME)\Desktop\arp.csv" -Force -NoTypeInformation -Delimiter ";"


#Routes
$Routes = Get-NetRoute -AddressFamily IPv4 | Select-Object @{l="ifDesc";e={(Get-NetAdapter -InterfaceIndex $_.ifIndex).ifDesc}}, `
                                                            DestinationPrefix, `
                                                            NextHop, `
                                                            RouteMetric, `
                                                            ifMetric

$Routes | Export-CSV -Path "C:\Users\$($env:USERNAME)\Desktop\route.csv" -Force -NoTypeInformation -Delimiter ";"


#Cache DNS
$DNS = Get-DnsClientCache | Select-Object Entry, Name, Type, TimeToLive, Data
$DNS | Export-CSV -Path "C:\Users\$($env:USERNAME)\Desktop\dns.csv" -Force -NoTypeInformation -Delimiter ";"


#NetBios
#...

#Partage Réseau
$NetDrives = Get-PSDrive -PSProvider FileSystem | ? {$_.DisplayRoot -like ("\\*")} | Select-Object Name, Root, DisplayRoot
$NetDrives | Export-CSV -Path "C:\Users\$($env:USERNAME)\Desktop\netdrives.csv" -Force -NoTypeInformation -Delimiter ";"


#Firewall rules
$FWRules = Get-NetFirewallRule | Select-Object DisplayName, ElementName, Enables, Profile, Direction, Action
$FWRules | Export-CSV -Path "C:\Users\$($env:USERNAME)\Desktop\fwrules.csv" -Force -NoTypeInformation -Delimiter ";"

#Firewall state
$FWState = Get-NetFirewallProfile | Select-Object Name, Enabled, LogFileName, DefaultInboundAction, DefaultOutboundAction
$FWState | Export-CSV -Path "C:\Users\$($env:USERNAME)\Desktop\fwstate.csv" -Force -NoTypeInformation -Delimiter ";"

#Services
$Services = Get-Service | Select-Object Name, DisplayName, Status, StartType
$Services | Export-CSV -Path "C:\Users\$($env:USERNAME)\Desktop\services.csv" -Force -NoTypeInformation -Delimiter ";"

#Processus
Get-WmiObject win32_Process | Select-Object Name, ProcessId, @{l="StartDate";e={$_.CreationDate.ConvertToDateTime()}}, @{l="Owner";e={$_.GetOwner().User}}
