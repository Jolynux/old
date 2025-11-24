#! /bin/bash

date=$(date +"%H:%M:%S")
errors="/var/log/audit/audit_errors.txt"
menu_choice=""

menuprincipal(){

clear
cat << EOF

#############################################################################
############################# Menu ENUMERATION ##############################
#############################################################################

Faites votre choix

1 : scan réseau
2 : scan domaine
3 : scan web

EOF

echo -n "Choix : "
read -r menu_choice
return "$menu_choice"    
}

menu_web(){

local type_choice=""
local site=""
local dictionary=""
local report=""

cat << END

f : fast scan
a : agressive
s : silent/smart
n : normal
paranoid : very very long scan (ajouter des techniques avancées ?)

END
    echo -n "Choix : "
    read -r type_choice
    echo "http address to scan : "
    read -r site
    echo -e "\nOù enregistrer le rapport ? (chemin/complet/nom_du_fichier.extension)\n: " 
    read -r report

    case "$type_choice" in

        f ) ffuf -u "$site/FUZZ" -o "$report";;

            cat "$report" ;;

        a ) dirsearch -e php,html,js -u "$site" -w "$dictionary" -r -t 40 -o "$report" ;;
            
            cat "$report" ;;

        s ) dirsearch -u "$site" -w "$dictionary" -r -t 15 -o "$report" ;;
            
            cat "$report" ;;

        n ) ffuf -w "$dictionary" -u "$site/FUZZ" -o "$report" ;;
            dirsearch -u "$site" -w "$dictionary" -r -o "$report" ;;
            
            cat "$report" ;;

        paranoid ) dirsearch -e php,html,js -u "$site" -w "$dictionary" -r --proxylist proxyservers.txt -t 10 -o "$report" ;;
            
        ? ) echo "error"
            return 1 ;;
            
        * ) echo "error"
            return 1 ;;
    esac
    echo "Scan terminé !"

    return 0
}

menu_domaine(){

local type_choice=""
local domain=""
local dictionary=""
local report=""

cat << END

FUZZING domain

f : ffuf
a : dirsearch
s : silent scan
paranoid : very very long scan

END
    echo -n "Choix : "
    read -r type_choice
    echo "Domain : "
    read -r domain
    echo -e "\nOù enregistrer le rapport ? (chemin/complet/nom_du_fichier.extension)\n: " 
    read -r report

    case "$type_choice" in

        f ) ffuf -w "$dictionary" -u "http://$domain/" -H "Host: FUZZ.$domain" ;;

        
        ? ) echo "error"
            return 1 ;;
            
        * ) echo "error"
            return 1 ;;
    esac
    echo "Scan terminé !"

    return 0
}

menu_reseau(){
local type_choice=""
local ip_cible=""
local report=""

cat << END

f : fast scan (Well known ports)
a : agressive
s : silent/smart
n : normal
oaa : *one after all* - begin by agressive, then normal and finish by silent

END
    echo -n "Choix : "
    read -r choice
    echo "Ip cible : "
    read -r ip_cible
    echo -e "\nOù enregistrer le rapport ? (chemin/complet/nom_du_fichier.extension)\n: " 
    read -r report

    case "$type_choice" in
        f ) nmap "$ip_cible" -p- >> "$report" 2>>"$date - $errors" ;;

        a ) nmap -A "$ip_cible" -Pn -p- -T5 >> "$report" 2>>"$date - $errors" ;;
            nmap -sU -sV "$ip_cible" -Pn -p- -T5 >> "$report" 2>>"$date - $errors" ;;

        s ) nmap -sSU -sC -sV "$ip_cible" -Pn -p- -v -T2 >> "$report" 2>>"$date - $errors" ;;
            
        n ) nmap -sV "$ip_cible" -Pn -p- >> "$report" 2>>"$date - $errors" ;;
            nmap -sU -sV "$ip_cible" -Pn -p- >> "$report" 2>>"$date - $errors" ;;

        oaa ) echo -e "########## AGGRESSIVE SCAN ##########\n" >> "$report" ;;

            nmap -A "$ip_cible" -Pn -p- -T5 >> "$report" 2>>"$date - $errors" ;;
            nmap -sU -sV "$ip_cible" -Pn -p- -T5 >> "$report" 2>>"$date - $errors" ;;

            echo -e "\n\n########## NORMAL SCAN ##########\n" >> "$report" ;;

            nmap -sV "$ip_cible" -Pn -p- >> "$report" 2>>"$date - $errors" ;;
            nmap -sU -sV "$ip_cible" -Pn -p- >> "$report" 2>>"$date - $errors" ;;

            echo -e "\n\n########## SILENT SCAN ##########\n" >> "$report" ;;

            nmap -sS -sV "$ip_cible" -Pn -p- -v -T2 >> "$report" 2>>"$date - $errors" ;;
            nmap -sU -sV "$ip_cible" -Pn -p- -v -T2 >> "$report" 2>>"$date - $errors" ;;
            
        ? ) echo "error"
            return 1 ;;
            
        * ) echo "error"
            return 1 ;;
    esac
    echo "Scan terminé !"

    return 0
}

menuprincipal 2>/dev/null
case "$menu_choice" in
    1 ) menu_reseau ;;
    2 ) menu_domaine ;;
    3 ) menu_web ;;
    ? ) echo "error"
        exit 1 ;;
    * ) echo "error"
        exit 1 ;;
esac

exit 0

