#!/usr/bin/env bash

ARCH='arch-chroot /mnt /bin/bash'

function ajustarReloj(){
	timedatectl set-ntp true
}

function instalarPaquetes(){
    yes | pacstrap /mnt base base-devel \
        neovim python-neovim python2-neovim \
        tmux networkmanager grub os-prober git \
        curl yajl openssl openssh
}

function generarFstab(){
    genfstab -U /mnt >> /mnt/etc/fstab
}

function ajustarZoneTime(){
    $ARCHROOT ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
    $ARCHROOT /usr/bin/hwclock --systohc
    printf '\nZona horaria:\n'
    $ARCHROOT /usr/bin/stat /etc/localtime
}

function generarLocale(){
    sed -ri "s/^#\s*(en_US.UTF-8.*)$/\1/" /mnt/etc/locale.gen
    sed -ri "s/^#\s*(es_ES.UTF-8.*)$/\1/" /mnt/etc/locale.gen
    $ARCHROOT /usr/bin/locale-gen
    printf 'LANG=en_US.UTF-8\n' > /mnt/etc/locale.conf
    printf '\nConfiguración de locales: '
    cat /mnt/etc/locale.conf
}

function configurarTeclado(){
    printf 'KEYMAP=es\n' > /mnt/etc/vconsole.conf
    printf '\nMapa de teclado: '
    cat /mnt/etc/vconsole.conf
}

function darNombre(){
    printf 'archlinux\n' > /mnt/etc/hostname
    printf '127.0.1.1\t\t archlinux.localdomain archlinux\n' >> /mnt/etc/hosts
    printf '\nHostname: '
    cat /mnt/etc/hostname
    printf '\nContenido de hosts:\n'
    cat /mnt/etc/hosts
}

function configurarRed(){
    $ARCHROOT /usr/bin/systemctl enable NetworkManager.service
}

function asignarPassword(){
    $ARCHROOT printf 'root\nroot\n' | passwd
}

function opcionesGrub(){
    sed -r 's/(GRUB_CMDLINE_LINUX_DEFAULT="quiet.*)"/\1 net.ifnames=0"/' /mnt/etc/default/grub
    read -p 'Introduce el disco'
    $ARCHROOT /usr/bin/grub-install
}

ajustarReloj
instalarPaquetes
generarFstab
ajustarZoneTime
generarLocale
configurarTeclado
darNombre
configurarRed
asignarPassword
