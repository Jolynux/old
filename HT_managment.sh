#! /bin/bash

version=1.0
OPTERR=0
max_cpus=$(($(lscpu --extended | tail -n1 | awk '{print $1}') + 1))

while getopts "edc:vh-:" option; do

    if [ "$option" = "-" ] ; then
        case $OPTARG in
            help ) option=h
            ;;
            version ) option=v
            ;;
            choose ) option=c
            ;;
            disable ) option=d
            ;;
            enable ) option=e
            ;;

            : ) echo "Option $OPTARG not set"
            ;;
            * ) echo "Option $OPTARG not know"
            ;;
        esac
    fi
    case "$option" in 
        d ) echo ""
            echo "disabling hyperthreading - only CPU 0 will be activated"
            echo ""
            for i in $(cat /sys/devices/system/cpu/cpu*/topology/thread_siblings_list | sort -un)
            do
                i=$((i + 1))
                if [[ "$i" -ge "$max_cpus" ]] ; then
                    echo -e "\nall CPUs are disabled\n"
                else
                    echo 0 > /sys/devices/system/cpu/cpu$i/online
                    if [[ $? == 0 ]] ; then
                        echo "cpu $i has been disabled"
                    else
                        echo "error on disabling CPU $i, continue(c) any other entry will stop this script"
                        read -p "Choice : " choice1
                        if [[ "$choice1" != 'c' ]] ; then
                            echo "OK STOP, see current status of CPUs :"
                            echo ""
                            lscpu --extended
                            exit 1
                        else
                            echo "OK continuing"
                        fi

                    fi 
                fi
                
            done
            echo "Finished, see current status of CPUs :"
            echo ""
            lscpu --extended
        ;;
        e ) echo ""
            echo "enabling hyperthreading for all CPUs"
            echo ""
            for i in $(find /sys/devices/system/cpu/cpu* -name online)
            do 
                echo 1 > $i
                if [[ $? == 0 ]] ; then
                    cpu_act=$(echo $i | cut -d '/' -f6)
                    echo "$cpu_act has been enabled"
                else
                    echo "error on disabling CPU $i, continue(c) any other entry will stop this script"
                    read -p "Choice : " choice2
                    if [[ "$choice2" != 'c' ]] ; then
                        echo "OK STOP, see current status of CPUs :"
                        echo ""
                        lscpu --extended
                        exit 1
                    else
                        echo "OK continuing"
                    fi

                fi 
            done
            echo ""
            echo "Finished, see current status of CPUs :"
            echo ""
            lscpu --extended
        ;;
        c ) j=1 ; choosed_cores=0 ;
                for i in $(cat /sys/devices/system/cpu/cpu*/topology/thread_siblings_list | sort -un)
                do
                    i=$((i + 1))
                    if [[ "$i" -ge "$max_cpus" ]] ; then
                        echo -e "\nall CPUs are disabled"
                    else
                        echo 0 > /sys/devices/system/cpu/cpu$i/online
                    fi
                done       
            echo ""
            echo "enabling hyperthreading for selected CPUs : "
            echo ""
            while [[ -n $choosed_cores ]]
            do
                choosed_cores=$(echo "$OPTARG," | cut -d ',' -f$j)
                if [[ $choosed_cores = *-* ]] ; then
                    first_core=$(echo $choosed_cores | cut -d '-' -f1)
                    last_core=$(echo $choosed_cores | cut -d '-' -f2)
                    while [[ "$first_core" -le "$last_core" ]] && [[ "$last_core" -le "$max_cpus" ]] && [[ "$first_core" -gt 0 ]] ; do
                        for k in $(find /sys/devices/system/cpu/cpu$first_core -name online)
                        do 
                            echo 1 > $k
                            if [[ $? == 0 ]] ; then
                                cpu_act=$(echo $k | cut -d '/' -f6)
                                echo "$cpu_act has been enabled"
                            else
                                echo "error on disabling CPU $i, continue(c) any other entry will stop this script"
                                read -p "Choice : " choice3
                                if [[ "$choice3" != 'c' ]] ; then
                                    echo "OK STOP, see current status of CPUs :"
                                    echo ""
                                    lscpu --extended
                                    exit 1
                                else
                                    echo "OK continuing"
                                fi

                            fi 
                        done
                        first_core=$((first_core + 1))
                    done
                elif [[ $choosed_cores =~ ^-?[0-9]+$ ]] && [[ $choosed_cores != *-* ]] ; then
                    for l in $(find /sys/devices/system/cpu/cpu$choosed_cores -name online)
                    do 
                        echo 1 > $l
                        if [[ $? == 0 ]] ; then
                            cpu_act=$(echo $l | cut -d '/' -f6)
                            echo "$cpu_act has been enabled"
                        else
                            echo "error on disabling CPU $i, continue(c) any other entry will stop this script"
                            read -p "Choice : " choice4
                            if [[ "$choice4" != 'c' ]] ; then
                                echo "OK STOP, see current status of CPUs :"
                                echo ""
                                lscpu --extended
                                exit 1
                            else
                                echo "OK continuing"
                            fi

                        fi 
                    done
                 
                fi
                j=$((j + 1))
            done
            echo ""
            echo "Finished, see current status of CPUs :"
            echo ""
            lscpu --extended
        ;;
        h ) echo "Syntaxe : $(basename $0) [ option... "
            echo "Options :"
            echo "-----------------------------"
            echo "-e --enable : enable hyperthreading"
            echo "-d --disable : disable hyperthreading"
            echo "-c --choose : select which CPU/Core to enable (ex : 2,5-7,18-20,23 ) // thread 0 is enabled by default //"
            echo "-----------------------------"
            echo "-v --version : Print version"
            echo "-h --help : Print help Screen"
        ;;
        v ) echo "Version : $(basename $0) $version"
        ;;
        ? ) echo "Option $OPTARG not known"
        ;;
    esac

done
shift $((OPTIND -1))
while [ $# -ne 0 ]; do
    echo "Argument suivant : " $1
    shift
done
