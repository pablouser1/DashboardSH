#!/bin/bash
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
   echo "Don't run this script as root!"
   exit 1
fi

source ./helpers.bash
helpers_source_dir './modules'

main() {
    local choise=$(
    whiptail --title "Dashboard" --menu "Pick a module" 0 0 0 \
    	"1" "NGINX" \
        "2" "Stats" \
        "3" "PersonalHub" \
        "4" "SchedOrganizer" \
        "5" "Notes" 3>&2 2>&1 1>&3
    )

    case $choise in
        1) nginx_menu ;;
        2) stats_menu ;;
        3) personalhub_menu ;;
        4) schedoroganizer_menu ;;
        5) notes_menu ;;
    esac

}

main $*
