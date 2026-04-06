STATS_GOACCESS="/usr/bin/goaccess"
STATS_ROOTHTML="/var/www/stats"
STATS_GEOLITE2="$SCRIPT_DIR/files/GeoLite2-City.mmdb"
STATS_SITE="stats.pabloferreiro.es"

stats_generate() {
    local site=$1
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
    for choise in $choises; do
        case "$choise" in
            1) arguments="$arguments --geoip-database $STATS_GEOLITE2" ;;
            2) arguments="$arguments --anonymize-ip --anonymize-level 3" ;;
            3) arguments="$arguments -a -o $STATS_ROOTHTML/$site.html" ;;
        esac
    done

    sudo $STATS_GOACCESS "$log_path" $arguments
}
