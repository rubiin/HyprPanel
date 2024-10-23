#!/bin/bash

check_flatpak_updates() {
    result=$(flatpak remote-ls --updates | wc -l)
    echo "$result"
}

check_arch_updates() {
    flatpak_updates=0

    official_updates=$(checkupdates 2>/dev/null | wc -l)
    aur_updates=$(yay -Qum 2>/dev/null | wc -l)

    if (command -v flatpak &>/dev/null); then
        flatpak_updates=$(check_flatpak_updates)
    fi

    total_updates=$((official_updates + aur_updates + flatpak_updates))

    echo "{\"total\":\"$total_updates\", \"tooltip\":\"󱓽  Official $official_updates\n󱓾  AUR $aur_updates\n󰏓  Flatpak $flatpak_updates\"}"
}

check_ubuntu_updates() {

    flatpak_updates = 0
    official_updates=$(apt-get -s -o Debug::NoLocking=true upgrade | grep -c ^Inst)

    if (command -v flatpak &>/dev/null); then
        flatpak_updates=$(check_flatpak_updates)
    fi

    total_updates=$((official_updates + aur_updates + flatpak_updates))

    echo "{\"total\":\"$total_updates\", \"tooltip\":\"󱓽  Official $official_updates\n󰏓  Flatpak $flatpak_updates\"}"
}

check_fedora_updates() {
    flatpak_updates = 0
    official_updates=$(dnf check-update -q | grep -v '^Loaded plugins' | grep -v '^No match for' | wc -l)

    if (command -v flatpak &>/dev/null); then
        flatpak_updates=$(check_flatpak_updates)
    fi

    total_updates=$((official_updates + aur_updates + flatpak_updates))

    echo "{\"total\":\"$total_updates\", \"tooltip\":\"󱓽  Official $official_updates\n󰏓  Flatpak $flatpak_updates\"}"
}

case "$1" in
-arch)
    check_arch_updates
    ;;
-ubuntu)
    check_ubuntu_updates
    ;;
-fedora)
    check_fedora_updates
    ;;
*)
    echo "0"
    ;;
esac
