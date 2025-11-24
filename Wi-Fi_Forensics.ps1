# Set-execution Plicy bypass
$wifi=@()

# visualisation des réseaux bloqués
$cmd0=netsh wlan show blockednetworks

# liste des SSID
$cmd1=netsh wlan show profiles
ForEach($row1 in $cmd1)

{
    # recup ssid regex
    if($row1 -match 'Profil Tous les utilisateurs[^:]+:.(.+)$')
    {
        $ssid=$Matches[1]
        $cmd2=netsh wlan show profiles $ssid key=clear
        ForEach($row2 in $cmd2)
        {
            # recup cle wifi
            if($row2 -match 'Contenu de la c[^:]+:.(.+)$')
            {
                $key=$Matches[1]
                # stockage des ssid et clef dans tab
                $wifi+=[PSCustomObject]@{ssid=$ssid;key=$key}
            }
        }
    }
}

# export en CSV
$wifi | export-CSV -Path "C:Users\$($env:USERNAME)\Desktop\wifi.csv" -NoTypeInformation
# visu en tableau
# $wifi | Sort -Property ssid | Out-GridView -Title 'Clés des SSID du poste'
