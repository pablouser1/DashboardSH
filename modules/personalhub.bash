PERSONAL_HUB_ROOT=~/www/PersonalHub
PERSONAL_HUB_PUBLIC=/var/www/root
NPM_BIN=/usr/bin/npm

personalhub_rebuild() {
    current=$(pwd)

    cd $PERSONAL_HUB_ROOT
    $NPM_BIN run build
    cd $current

    sudo rm -rf $PERSONAL_HUB_PUBLIC/*
    sudo cp -r $PERSONAL_HUB_ROOT/dist/* $PERSONAL_HUB_PUBLIC
    sudo chown -R www-data:www-data $PERSONAL_HUB_PUBLIC
}

personalhub_pull_rebuild() {
    current=$(pwd)

    cd $PERSONAL_HUB_ROOT
    git pull
    $NPM_BIN i
    cd $current

    personalhub_rebuild
}

personalhub_menu() {
    local choise=$(
    whiptail --title "PersonalHub" --menu "Pick a subsection" 0 0 0 \
    	"1" "Rebuild" \
        "2" "Git pull & Rebuild" 3>&2 2>&1 1>&3
    )

    case $choise in
        1) personalhub_rebuild ;;
        2) personalhub_pull_rebuild ;;
    esac
}
