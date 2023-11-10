NGINX_AVAILABLE="/etc/nginx/sites-available"
NGINX_ENABLED="/etc/nginx/sites-enabled"
NGINX_LOGS="/var/log/nginx"

# Checks if a site is enable
#
# Arguments:
#   * Site name as string
#
# Returns:
#   * If that site is enabled
nginx_site_is_enabled() {
    local site=$1
    test -f "$NGINX_ENABLED/$site"
}

# Builds options from nginx sites for whiptail
#
# Arguments:
#   * List of sites as string
#
# Outputs:
#   * Whiptail options
nginx_get_whiptail_options() {
    local sites=$1
    local options=""

    local i=1
    for enabled_site in $enabled_sites; do
        options="$options $i $enabled_site"
        i=$((i + 1))
    done

    echo $options
}

# Get all sites enabled
#
# Globals:
#   * NGINX_AVAILABLE
#
# Outputs:
#   * Available sites separated by \n
nginx_get_enabled_sites() {
    ls -1 "$NGINX_AVAILABLE"
}

# Apply changes
nginx_apply_changes() {
    if sudo systemctl reload nginx; then
        whiptail --title "NGINX Sites" --msgbox "Changes applied successfully" 0 0
    fi
}

# Enables a site
#
# Arguments:
#   * Name of site
nginx_enable_site() {
    local site=$1

    if nginx_site_is_enabled $site; then
        whiptail --title "NGINX Sites" --msgbox "This site is already enabled" 0 0
        return
    fi

    sudo ln -s "$NGINX_AVAILABLE/$site" "$NGINX_ENABLED/$site"

    nginx_apply_changes
}

# Disables a site
#
# Arguments:
#   * Name of site
nginx_disable_site() {
    local site=$1

    if ! nginx_site_is_enabled $site; then
        whiptail --title "NGINX Sites" --msgbox "This site is already disabled" 0 0
        return
    fi

    sudo rm "$NGINX_ENABLED/$site"

    nginx_apply_changes
}

nginx_sites() {
    local enabled_sites=$(nginx_get_enabled_sites)
    local options=$(nginx_get_whiptail_options "$enabled_sites")

    local siteChoise=$(
        whiptail --title "NGINX Sites" --menu "Pick a site" 0 0 0 $options 3>&2 2>&1 1>&3
    )

    local site=$(echo "$enabled_sites" | sed -n "${siteChoise}p")

    local actionChoise=$(
        whiptail --title "$site" --menu "Pick an action" 0 0 0 \
            "1" "Enable" \
            "2" "Disable" 3>&2 2>&1 1>&3
    )

    case $actionChoise in
        1)
            # Enable site
            nginx_enable_site $site
            ;;
        2)
            # Disable site
            nginx_disable_site $site
            ;;
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
