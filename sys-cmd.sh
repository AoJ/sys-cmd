
# resources
# http://stackoverflow.com/questions/1562666/bash-scripts-whiptail-file-select
# http://en.wikibooks.org/wiki/Bash_Shell_Scripting/Whiptail
# http://misc.flogisoft.com/bash/tip_colors_and_formatting


db_file=COMMANDS
r_title="^>(.*)$"
r_cmd="^[a-z].*$"
r_comment="^\#(.*)$"
r_end="^[\s]*"
i=0
line=1

while read -r; do

#get first line and check if is a title
    if [[ $REPLY =~ $r_title ]]; then
        title=${BASH_REMATCH[1]}
        cmd=""
        comment=""

#get second (next) line and check if is a optional comment
    elif [[ $REPLY =~ $r_comment ]]; then
        comment=${BASH_REMATCH[1]}

# get next line and save cmd
    elif [[ $REPLY =~ $r_cmd ]]; then
        cmd=$REPLY
        cmd_line=$line

# if empty line process all row
    elif [[ $REPLY =~ $r_end ]]; then

        if [ ! -z "$title" ] && [ ! -z "$cmd" ]; then
#            printf "%s: %s >>>> %s\n" "$cmd_line" "$title" "$cmd"
            commands[i]="$cmd_line"
            commands[i+1]="$title"
            ((i+=2))
        fi
        title=""
        cmd=""
        comment=""
    fi
    ((line+=1))

done < $db_file

# eval `resize`
# $LINES $COLUMNS $(( $LINES - 8 ))
# http://en.wikibooks.org/wiki/Bash_Shell_Scripting/Whiptail
SELECT_CMD=$(whiptail --backtitle "AoJ cmds db" --title "Linux administration commands" \
    --menu "Select command to run" 30 70 22 "${commands[@]}"  3>&1 1>&2 2>&3)

COMMAND=$(sed "${SELECT_CMD}q;d" COMMANDS)


for arg in "$@"
do
  case "${arg}" in
    -q*|--quiet*)           key="-q";     QUIET=1;;
    -p*|--print*)           key="-s";     PRINT=1;;
  esac
done


# eval command
if [ -z "$PRINT" ]; then
    eval $COMMAND
fi

# print info and command
if [ -z "$QUIET" ]; then
    echo ""
    echo -e "\e[40mcmd from line ${SELECT_CMD}: USE IT:  \e[92msed '${SELECT_CMD}q;d' COMMANDS\e[39m\e[49m"
    echo -e "\e[40m\e[1m\e[93m$COMMAND \e[39m\e[21m\e[49m"
fi
