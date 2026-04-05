NGINX_AVAILABLE="/etc/nginx/sites-available"
NGINX_ENABLED="/etc/nginx/sites-enabled"
NGINX_LOGS="/var/log/nginx"

# Checks if a site is enable
#
# Arguments:
#   * Site name
#
# Returns:
#   * If that site is enabled
nginx_site_is_enabled() {
    local site=$1
    test -f "$NGINX_ENABLED/$site"
}

# Checks if a site is enable and returns as verb
#
# Arguments:
#   * Site name
#
# Returns:
#   * 'ON' if enabled, 'OFF' if not
nginx_site_is_enabled_verb() {
    local site=$1

    if nginx_site_is_enabled "$site"; then
        echo "ON"
    else
        echo "OFF"
    fi
}

# Builds options from nginx sites for whiptail
#
# Arguments:
#   * List of sites
#
# Outputs:
#   * Whiptail options
nginx_get_whiptail_options() {
    local sites=$1
    local options=""

    local i=1
    for site in $sites; do
        options="$options $i $site"
        i=$((i + 1))
    done

    echo $options
}

# Get all sites available
#
# Globals:
#   * NGINX_AVAILABLE
#
# Outputs:
#   * Available sites separated by \n
nginx_get_available_sites() {
    ls -1 "$NGINX_AVAILABLE"
}

# Apply changes
nginx_apply_changes() {
    if sudo systemctl reload nginx; then
        whiptail --title "NGINX Sites" --msgbox "Changes applied successfully" 0 0
    fi
}

# Toggle state of site
#
# Arguments:
#   * Site name
#
# Globals:
#   * NGINX_AVAILABLE
#   * NGINX_ENABLED
nginx_toggle_site() {
    local site=$1

    if nginx_site_is_enabled $site; then
        # Remove enabled
        sudo rm "$NGINX_ENABLED/$site"
    else
        # Do ln to enable
        sudo ln -s "$NGINX_AVAILABLE/$site" "$NGINX_ENABLED/$site"
    fi

    nginx_apply_changes
}

# List all sites and run actions
nginx_sites() {
    # List all sites
    local available_sites=$(nginx_get_available_sites)
    local options=$(nginx_get_whiptail_options "$available_sites")
    local siteChoise=$(
        whiptail --title "NGINX Sites" --menu "Toggle a site" 0 0 0 $options 3>&2 2>&1 1>&3
    )

    # Pick action for site
    local site=$(echo "$available_sites" | sed -n "${siteChoise}p")
    local status=$(nginx_site_is_enabled_verb "$site")
    local actionChoise=$(
        whiptail --title "$site" --menu "Current status is $status" 0 0 0 \
            "1" "Toggle" \
            "2" "Stats" 3>&2 2>&1 1>&3
    )

    case $actionChoise in
        1)
            # Toggle site
            nginx_toggle_site "$site"
            ;;
        2)
            # Generate stats
            stats_generate "$site"
    esac
}


nginx_menu() {
    local choise=$(
    whiptail --title "NGINX" --menu "Pick a subsection" 0 0 0 \
    	"1" "Sites" 3>&2 2>&1 1>&3
    )

    case $choise in
        1) nginx_sites ;;
    esac
}
