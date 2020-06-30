#!/usr/bin/env bash
# Main script for the installation,
# which calls all other scripts

# Disable warning about variables not being assigned (since they are in other files)
# shellcheck disable=SC2154

###############################################################
### Trap Linux Install Script
###
### Copyright (C) 2020 Pugemon
###
### By: Pugemon (deadhead)
###
###
### License: GPL v2.0
###
### This program is free software; you can redistribute it and/or
### modify it under the terms of the GNU General Public License
### as published by the Free Software Foundation; either version 2
### of the License, or (at your option) any later version.
###
### This program is distributed in the hope that it will be useful,
### but WITHOUT ANY WARRANTY; without even the implied warranty of
### MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
### GNU General Public License for more details.
###
### You should have received a copy of the GNU General Public License
### along with this program; if not, write to the Free Software
### Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
################################################################

init() {
    if [[ $(basename "$0") = "trap" ]]; then
        trap_directory="/usr/share/trap" # prev: ta_dir
        trap_config="/etc/trap.conf" # prev: ta_conf
        trap_scripts="/usr/lib/trap" # prev: ta_lib
    else
        trap_directory=$(dirname "$(readlink -f "$0")") # Trap git repository
        trap_config="${trap_directory}"/etc/trap.conf
        trap_scripts="${trap_directory}"/lib
    fi

    trap '' 2

    for script in "${trap_scripts}"/*.sh ; do
        [[ -e "${script}" ]] || break
        # shellcheck source=/usr/lib/trap/*.sh
        source "${script}"
    done

    # shellcheck source=/etc/trap.conf
    source "${trap_config}"
    language
    # shellcheck source=/usr/share/trap/lang
    source "${lang_file}" # /lib/language.sh:43-60
    export reload=true
}

main() {
    set_keys
    update_mirrors
    check_connection
    set_locale
    set_zone
    prepare_drives
    install_options
    set_hostname
    set_user
    add_software
    install_base
    configure_system
    add_user
    reboot_system
}

dialog() {
    # If terminal height is more than 25 lines add a backtitle
    if "${screen_h}" ; then # /etc/trap.conf:62
        if "${LAPTOP}" ; then # /etc/trap.conf:75
            # Show battery life next to Trap heading
            backtitle="${backtitle} $(acpi)"
        fi
        # op_title is the current menu title
        /usr/bin/dialog --colors --backtitle "${backtitle}" --title "${op_title}" "$@"
    else
        # title is the main title (Trap)
        /usr/bin/dialog --colors --title "${title}" "$@"
    fi
}

if [[ "${UID}" -ne "0" ]]; then
    echo "Error: trap requires root privilege"
    echo "       Use: sudo trap"
    exit 1
fi

# Read optional arguments
opt="$1" # /etc/trap.conf:105
init
main

# vim: ai:ts=4:sw=4:et
