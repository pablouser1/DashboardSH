STATS_GOACCESS="/usr/bin/goaccess"
STATS_ROOTHTML="/var/www/stats"
STATS_GEOLITE2="./files/GeoLite2-City.mmdb"

stats_generate() {
    # Pick NGINX site
    local enabled_sites=$(nginx_get_enabled_sites)
    local options=$(nginx_get_whiptail_options $enabled_sites)
    local siteChoise=$(
        whiptail --title "Stats Generator" --menu "Pick a site" 0 0 0 $options 3>&2 2>&1 1>&3
    )
    local site=$(echo "$enabled_sites" | sed -n "${siteChoise}p")
    local site_path="$NGINX_AVAILABLE/$site"
    local log_path=$(awk '/access_log/ {gsub(/;/,"",$2); print $2}' "$site_path")

    # Arguments for GoAccess
    local choises=$(
        whiptail --title "Stats Generator" --separate-output --checklist "Choose your options" 0 0 0 \
            "1" "Enable GeoLite2" OFF \
            "2" "Anonymize IPs" OFF \
            "3" "Output HTML" OFF 3>&2 2>&1 1>&3
    )

    local arguments=""
    local isHTML=false
    for choise in $choises; do
        case "$choise" in
            1) arguments="$arguments --geoip-database $STATS_GEOLITE2" ;;
            2) arguments="$arguments --anonymize-ip --anonymize-level 3" ;;
            3) arguments="$arguments -a -o $STATS_ROOTHTML/$site.html" ;;
        esac
    done

    sudo $STATS_GOACCESS "$log_path" $arguments
}

stats_menu() {
    local choise=$(
    whiptail --title "Stats" --menu "Pick a subsection" 0 0 0 \
    	"1" "Generate" 3>&2 2>&1 1>&3
    )

    case $choise in
        1) stats_generate ;;
    esac
}
