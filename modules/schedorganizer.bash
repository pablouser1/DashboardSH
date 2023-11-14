SCHEDORGANIZER_ROOT=/var/www/html/horarios
SCHEDORGANIZER_BIN=SchedOrganizer

schedoroganizer_upgrade() {
    current=$(pwd)

    cd $SCHEDORGANIZER_ROOT

    sudo -u www-data git pull
    sudo -u www-data go build -ldflags "-s -w" .
    sudo systemctl restart schedorganizer
    cd $current
}

schedoroganizer_cli() {
    current=$(pwd)

    cd $SCHEDORGANIZER_ROOT
    sudo -u www-data ./$SCHEDORGANIZER_BIN --cli

    cd $current
}

schedoroganizer_menu() {
    local choise=$(
    whiptail --title "SchedOrganizer" --menu "Pick a subsection" 0 0 0 \
    	"1" "Upgrade" \
        "2" "CLI" 3>&2 2>&1 1>&3
    )

    case $choise in
        1) schedoroganizer_upgrade ;;
        2) schedoroganizer_cli ;;
    esac
}
