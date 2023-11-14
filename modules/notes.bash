NOTES_ROOT=/var/www/html/apuntes
HUGO_BIN=/usr/bin/hugo

notes_upgrade() {
    current=$(pwd)

    cd $NOTES_ROOT

    sudo -u www-data git pull
    sudo -u www-data $HUGO_BIN
    cd $current
}

notes_menu() {
    local choise=$(
    whiptail --title "Notes" --menu "Pick a subsection" 0 0 0 \
    	"1" "Upgrade" 3>&2 2>&1 1>&3
    )

    case $choise in
        1) notes_upgrade ;;
    esac
}
