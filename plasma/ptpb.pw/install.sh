#!/usr/bin/env bash

function crearRutas(){
    serviceMenusPath="$HOME/.local/share/kservices5/ServiceMenus"
    [[ ! -d "$serviceMenusPath" ]] && {
        mkdir -p "${serviceMenusPath}"
        [[ $? != 0 ]] && {
            printf "Hubieron errores creando la ruta: ${serviceMenusPath}...\nSaliendo..\n";
            exit 1;
        };
    }
    scriptPath="$HOME/.local/bin"
    [[ ! -d "$scriptPath" ]] && { 
        mkdir -p "${scriptPath}"
        [[ $? != 0 ]] && {
            printf "Hubieron errores creando la ruta: ${scriptPath}...\nSaliendo..\n";
        exit 1;
        };
    }
}

function descargarFicheros(){
    serviceFile='sendtoptpb.desktop'
    curl -o "${serviceMenusPath}/${serviceFile}" 'https://raw.githubusercontent.com/manuel-alcocer/archlinux-install/master/plasma/ptpb.pw/ServiceMenus/sendtoptpb.desktop'
    scriptFile='ptpb.pw.sh'
    curl -o "${scriptPath}/${scriptFile}" 'https://raw.githubusercontent.com/manuel-alcocer/archlinux-install/master/plasma/ptpb.pw/bin/ptpb.pw.sh'
}


function configurarFicheros(){
    chmod u+x "${scriptPath}/${scriptFile}"
    [[ $? != 0 ]] && {
        printf 'Hubieron errores dando permisos de ejeción al ejecutable...\n';
        printf 'La instalación no está completa\n';
    }
    sed -i "s/usuario/$USER/" "${serviceMenusPath}/${serviceFile}"
    [[ $? != 0 ]] && {
        printf 'Hubieron errores cambiando la ruta del ejecutable...\n';
        printf 'La instalación no está completa\n';
    }
}

crearRutas
descargarFicheros
configurarFicheros

