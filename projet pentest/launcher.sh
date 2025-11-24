#! /bin/bash

# uniquement pour apprendre

menu_choice=""
enum_submenu="./enum.sh"
bruteforce_submenu="./bruteforce.sh"
stegano_submenu="./stegano.sh"

menuprincipal(){

clear
cat << EOF

#############################################################################
########################## Bienvenue dans mon menu ##########################
#############################################################################
    
Ceci est un projet perso qui souhaite automatiser les bases du receuil d'informations préalables à l'exploitation de failles.
    
Faites votre choix

1 : énumération
2 : bruteforce
3 : stegano

EOF

echo -n "Choix : "
read -r menu_choice
return "$menu_choice"    
}
menuprincipal 2>/dev/null

case $menu_choice in 
    1 ) $enum_submenu ;;
    2 ) $bruteforce_submenu ;; 
    3 ) $stegano_submenu ;;  
    ? ) echo "option illégale"
        exit 1 ;; 
    * ) echo "option illégale" 
        exit 1 ;;
esac

exit 0