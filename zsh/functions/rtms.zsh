rtms_t() {
    xdg-open "https://rtms.intrinsec.com/?do=edit_ticket&id=$*"
}

rtms() {
    if [ -z "$1" ]; then
        echo 'Usage : rtms PORT [USER] [TUNNEL 80:127.0.0.1:80]'
    else
        SSH_BIN=`which ssh`
        SSH_IP='rtms'
        SSH_PORT="$1"
        SSH_CMD="$SSH_BIN -Y $SSH_IP -p $SSH_PORT"

        if [ -z "$2" ]; then
            SSH_CMD="$SSH_CMD -l admisec"
        else
            SSH_CMD="$SSH_CMD -l $2"
        fi
        if [ -n "$3" ]; then
            SSH_CMD="$SSH_CMD -L $3"
        fi
        $=SSH_CMD
    fi
}
rtms_push() {
    if [ -z "$2" ]; then
        echo 'Usage : rtms_push SSH_PUB PORT (USER)'
    else
        SSH_PUB=$1
        PORT=$2
        SSH_LOGIN=$3
        if [ -f "$SSH_PUB" ]; then
            IP='rtms'
            if [ -z "$SSH_LOGIN" ]; then
                SSH_LOGIN='admisec'
            fi
            ssh-copy-id -p $PORT -i $SSH_PUB $SSH_LOGIN@$IP
        else
            echo "$SSH_PUB not found"
        fi
    fi
}
