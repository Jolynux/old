#! /bin/bash

date=$(date +"%H:%M:%S")
menu_choice=""
report=""
errors="/var/log/audit/audit_errors.txt"
ip_cible=""
port_cible=""
dictionary=""
users=""

menuprincipal(){

clear
cat << EOF

#############################################################################
############################# Menu BRUTEFORCE ###############################
#############################################################################

Faites votre choix

1 : Bruteforce web
2 : Bruteforce file
3 : bruteforce protocol

EOF

echo -n "Choix : "
read -r menu_choice
return "$menu_choice"    
}

menu_web(){
local type_choice=""

cat << END

w : Wordpress admin panel
a : Other admin panel
l : local user

END
    echo -n "Choix : "
    read -r choice
    echo "Ip cible : "
    read -r ip_cible
    echo "Port : "
    read -r port_cible
    echo -e "\nOù enregistrer le rapport ? (chemin/complet/nom_du_fichier.extension)\n: " 
    read -r report

    case "$type_choice" in
        w ) ;;
        a ) ;;
        l ) ;;
        ? ) echo "error"
            return 1 ;;
            
        * ) echo "error"
            return 1 ;;
    esac
    echo "Bruteforce terminé !"

    return 0
}

menu_file(){
local type_choice=""
local ftocrack=""


cat << END

1 : hash
2 : fichier chiffré
3 : je sais pas ?

END
    echo -n "Choix : "
    read -r type_choice
    echo "fichier à bruteforce : "
    read -r ftocrack
    echo "Dictionnaire : "
    read -r dictionary
    echo -e "u:utilisateur (exemple : u:root)\nl:chemin/complet/dufichier.txt (exemple : l:/home/kali/list.txt)\nAutre choix = aucun\n:"
    read -r users
    echo -e "\nOù enregistrer le rapport ? (chemin/complet/nom_du_fichier.extension)\n: " 
    read -r report

local choose_type=$(echo "$users" | awk -F ":" '{print $1}')
local choosen_user=$(echo "$users" | awk -F ":" '{print $2}')

    if [ "$choose_type" = u ]; then

    elif [ "$choose_type" = l ]; then

    else
        # command sans utilisateur
    fi

    case "$type_choice" in
        1 ) ;;
        2 ) ;;

        3 ) ;;
        4 ) ;;

        5 ) echo "error"
            return 1 ;;
            
        * ) echo "error"
            return 1 ;;
    esac
    echo "Bruteforce terminé !"

    return 0
}

menu_protocol(){
local type_choice=""

cat << END

type protocol name to select in :
ssh
ftp
nfs
smb
smtp

END
    echo -n "Choix : "
    read -r type_choice
    echo "Ip cible : "
    read -r ip_cible
    echo -e "\nOù enregistrer le rapport ? (chemin/complet/nom_du_fichier.extension)\nATTENTION le script créé le fichier ou ajoute à la suite de celui existant.\n: " 
    read -r report

    case "$type_choice" in
        ssh ) ;;

        ftp ) ;;

        nfs ) ;;

        smb ) ;;

        smtp ) ;;


        ? ) echo "error"
            return 1 ;;
            
        * ) echo "error"
            return 1 ;;
    esac
    echo "Bruteforce terminé !\n"

    return 0
}

menu_wifi(){
    local type_choice=""

cat << END

1 : Bruteforce de mot de passe WPA/WPA2

END
    echo -n "Choix : "
    read -r type_choice
    echo "Ip cible : "
    read -r ip_cible
    echo -e "\nOù enregistrer le rapport ? (chemin/complet/nom_du_fichier.extension)\n: " 
    read -r report

    case "$type_choice" in
        1 ) ;;
        
        ? ) echo "error"
            return 1 ;;
            
        * ) echo "error"
            return 1 ;;
    esac
    echo "Bruteforce terminé !"

    return 0
}

menu_database(){

local type_choice=""

cat << END

1 : Bruteforce d'identifiants de base de données
2 : Bruteforce de mots de passe stockés

END
    echo -n "Choix : "
    read -r type_choice
    echo "Ip cible : "
    read -r ip_cible
    echo -e "\nOù enregistrer le rapport ? (chemin/complet/nom_du_fichier.extension)\n: "
    read -r report

case "$type_choice" in
    1 ) ;;
    2 ) ;;

    ? ) echo "error"
        return 1 ;;
        
    * ) echo "error"
        return 1 ;;
esac
echo "Bruteforce terminé !"

return 0

}

menuprincipal 2>/dev/null
case "$menu_choice" in
    1 ) menu_web ;;
    2 ) menu_file ;;
    3 ) menu_protocol ;;
    ? ) echo "error"
        exit 1 ;;
    * ) echo "error"
        exit 1 ;;
esac

exit 0

