#!/usr/bin/env bash

ARCH='arch-chroot /mnt /bin/bash'

function ajustarReloj(){
	timedatectl set-ntp true
}

function instalarPaquetes(){
    pacstrap -y /mnt base base-devel \
        vim nvim curl yajl os-prober grub \
        git tmux networkmanager
}

function generarFstab(){
    genfstab -U /mnt >> /mnt/etc/fstab
}

function ajustarZoneTime(){
    $ARCHROOT ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
    $ARCHROOT /usr/bin/hwclock --systohc
}

function generarLocale(){
    sed -ri "s/^#\s*(en_US.UTF-8.*)$/\1/" /mnt/etc/locale.gen
    sed -ri "s/^#\s*(es_ES.UTF-8.*)$/\1/" /mnt/etc/locale.gen
    $ARCHROOT /usr/bin/locale-gen
    printf 'LANG=en_US.UTF-8\n' > /mnt/etc/locale.conf
}

function configurarTeclado(){
    printf 'KEYMAP=es\n' > /mnt/etc/vconsole.conf
}

function darNombre(){
    printf 'archlinux\n' > /mnt/etc/hostname
    printf '127.0.1.1\t\t archlinux.localdomain archlinux\n' >> /mnt/etc/hosts
}

function red(){
    $ARCHROOT /usr/bin/systemctl enable NetworkManager.service
}

ajustarReloj
instalarPaquetes
generarFstab
ajustarZoneTime
generarLocale
configurarTeclado
red
