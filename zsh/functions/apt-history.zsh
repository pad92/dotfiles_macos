### Author:      Benjamin York
### Date:        2011-01-08
###
### Based On:
### http://linuxcommando.blogspot.com/2008/08/how-to-show-apt-log-history.html
###
### Hosted At:
### https://github.com/blyork/apt-history
### 
### Git Repository:
### git://github.com/blyork/apt-history.git
###
### Description:
### Parses dpkg log files to get package installation, removal, and rollback
### information.
###
### Ubuntu Server likes to split up the dpkg.log file and then compress the
### various pieces. After seeing LinuxCommando's function, I added functionality
### to pull the pieces back together. I also slightly adjusted the output to
### avoid false positives.

function echoHistory() {
if [[ $1 == *.gz ]] ; then
    gzip -cd $1
else
    if [[ $1 == *.log || $1 == *.log.1 ]] ; then
        cat $1
    else
        echo "\*\*\* Invalid File: ${1} \*\*\*" 1>&2
    fi
fi
}

function apt-history() {
FILES=( `ls -rt /var/log/dpkg.log*` ) || exit 1

for file in "${FILES[@]}"
do
    case "$1" in
        install)
            echoHistory $file | grep " install "
            ;;

        upgrade|remove|purge)
            echoHistory $file | grep " ${1} "
            ;;

        rollback)
            echoHistory $file | grep upgrade | \
                grep "$2" -A10000000 | \
                grep "$3" -B10000000 | \
                awk '{print $4"="$5}'
            ;;

        *)
            echoHistory $file
            ;;
    esac
done
}
