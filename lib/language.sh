#!/usr/bin/env bash
###############################################################
### Trap Linux Install Script
### language.sh
###
###
###
###
### License: GPL v2.0
###############################################################

language() {

    echo "$(date -u "+%F %H:%M") : Start trap installer" > "${log}"
    op_title=" -| Language Select |- "
    ILANG=$(dialog --nocancel --menu "\nTrap Installer\n\n \Z2*\Zn Select your install language:" 20 60 10 \
        "English" "-" \
        "Russian" "Русский" 3>&1 1>&2 2>&3)

    case "$ILANG" in
        "English") export lang_file="${trap_directory}"/lang/english.conf ;;
        "Russian") export lang_file="${anarchy_directory}"/lang/russian.conf lib=ru bro=ru ;;
    esac

}

# vim: ai:ts=4:sw=4:et
