#!/usr/bin/env bash

function crearRutas(){
    applicationPath="$HOME/.local/share/applications"
    [[ ! -d "$applicationPath" ]] && {
        mkdir -p "${applicationPath}"
        [[ $? != 0 ]] && {
            printf "Hubieron errores creando la ruta: ${applicationPath}...\nSaliendo..\n";
            exit 1;
        };
    }
}

function descargarFicheros(){
    applicationFile='mpv-socket.desktop'
    curl -o "${applicationPath}/${applicationFile}" 'https://raw.githubusercontent.com/manuel-alcocer/archlinux-install/master/plasma/ptpb.pw/ServiceMenus/sendtoptpb.desktop'
}

crearRutas
descargarFicheros
