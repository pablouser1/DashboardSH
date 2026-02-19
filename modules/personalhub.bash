PERSONAL_HUB_ROOT="$HOME/www/PersonalHub"
PERSONAL_HUB_PUBLIC=/var/www/root
NPM_BIN=/usr/bin/npm

personalhub_upgrade() {
    current=$(pwd)

    cd $PERSONAL_HUB_ROOT

    git pull
    $NPM_BIN i
    $NPM_BIN run build
    cd $current

    sudo rm -rf $PERSONAL_HUB_PUBLIC/*
    sudo cp -r $PERSONAL_HUB_ROOT/dist/* $PERSONAL_HUB_PUBLIC
    sudo chown -R www-data:www-data $PERSONAL_HUB_PUBLIC
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
