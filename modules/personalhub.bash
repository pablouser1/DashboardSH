PERSONAL_HUB_ROOT=/var/www/html/root
YARN_BIN=/usr/bin/yarn

personalhub_upgrade() {
    current=$(pwd)

    cd $PERSONAL_HUB_ROOT

    sudo -u www-data git pull
    sudo -u www-data $YARN_BIN
    sudo -u www-data $YARN_BIN build
    cd $current
}

personalhub_menu() {
    local choise=$(
    whiptail --title "PersonalHub" --menu "Pick a subsection" 0 0 0 \
    	"1" "Upgrade" 3>&2 2>&1 1>&3
    )

    case $choise in
        1) personalhub_upgrade ;;
    esac
}
