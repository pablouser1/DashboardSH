#!/bin/bash
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
   echo "Don't run this script as root!" 
   exit 1
fi

source ./helpers.bash

source ./modules/nginx.bash
source ./modules/stats.bash

main() {
    local choise=$(
    whiptail --title "Dashboard" --menu "Pick a module" 0 0 0 \
    	"1" "NGINX" \
        "2" "Stats" 3>&2 2>&1 1>&3	
    )

    case $choise in
        1) nginx_menu ;;
        2) stats_menu ;;
    esac

}

main $*
