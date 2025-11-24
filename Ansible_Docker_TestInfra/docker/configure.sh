#! /bin/bash

########################################################
# This script :                                        #
# - Select port for different services                 #
# - Assign names for container from srv_01 to srv_99   #
# - Send an echo of the value for startenv.sh script   #
########################################################
func_ssh_port() {

        SSH_PORT=2222
        TEST_SSH=$(docker ps | grep "$SSH_PORT")
        while [[ -n $TEST_SSH ]]; do
                SSH_PORT=$((SSH_PORT + 1))
                TEST_SSH=$(docker ps | grep "$SSH_PORT")
        done
        echo "$SSH_PORT"

}

func_web_port() {
        
        WEB_PORT=8000
        TEST_WEB=$(docker ps | grep "$WEB_PORT")
        while [[ -n $TEST_WEB ]]; do
                WEB_PORT=$((WEB_PORT + 1))
                TEST_WEB=$(docker ps | grep "$WEB_PORT")
        done
        echo "$WEB_PORT"

}

func_sql_port() {
        
        SQL_PORT=14333
        TEST_SQL=$(docker ps | grep "$SQL_PORT")
        while [[ -n $TEST_SQL ]]; do
                WEB_PORT=$((WEB_PORT + 1))
                TEST_WEB=$(docker ps | grep "$SQL_PORT")
        done
        echo "$SQL_PORT"

}

func_name() {

        # Determine hostname
        PATTERN_NAME='srv_'
        NUMBER=01
        CONT_NAME="$PATTERN_NAME$NUMBER"
        TEST_CONT_NAME=$(docker ps -a | grep "$CONT_NAME")

        if [[ -z "$TEST_CONT_NAME" ]]; then
                echo "$CONT_NAME"
        else
                while [ "$TEST_CONT_NAME" != "" ]; do
                        NUMBER=$(printf "%02d" $((10#$NUMBER + 1)))
                        CONT_NAME="$PATTERN_NAME$NUMBER"
                        TEST_CONT_NAME=$(docker ps -a | grep "$CONT_NAME")
                done
                        echo "$CONT_NAME"
        fi

        # check /etc/hosts and modify it if needed
        NET_PATTERN='172.17.0.'
        TEST_HOST=$(cat /etc/hosts | grep "$CONT_NAME")
        if [[ $NUMBER < 10 ]]; then
            IP=$((${NUMBER:1:1} + 1))
        else
            IP=$((NUMBER + 1))
        fi
        
        if [[ -z $TEST_HOST ]]; then
                echo "$NET_PATTERN$IP $CONT_NAME" >> /etc/hosts
        fi
}

func_help() {

    echo 'function help !!!!!!!!!!'
    
}

case "$1" in
        ssh )
                if [[ "$1" == 'ssh' ]]; then
                        func_ssh_port
                else
                        echo "Error with entry : $1"
                        echo ""
                        func_help
                fi
                ;;
        web )
                if [[ "$1" == 'web' ]]; then
                        func_web_port
                else
                        echo "Error with entry : $1"
                        echo ""
                        func_help
                fi
                ;;
        sql )
                if [[ "$1" == 'sql' ]]; then
                        func_sql_port
                else
                        echo "Error with entry : $1"
                        echo ""
                        func_help
                fi
                ;;
        name )
                if [[ "$1" == 'name' ]]; then
                        func_name
                else
                        echo "Error with entry : $1"
                        echo ""
                        func_help
                fi
                ;;    
esac