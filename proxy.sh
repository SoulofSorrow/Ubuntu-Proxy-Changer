#!/bin/bash

# Pfad zur Konfigurationsdatei
CONFIG_FILE="/pfad/zur/proxy.conf"

# Funktion zum Lesen der Konfigurationsdatei
read_config() {
    . "$CONFIG_FILE"
}

# Funktion zum Setzen des Proxys
set_proxy() {
    export http_proxy="$PROXY_HOST:$PROXY_PORT"
    export https_proxy="$PROXY_HOST:$PROXY_PORT"
    export ftp_proxy="$PROXY_HOST:$PROXY_PORT"

    # Docker-Proxy setzen
    mkdir -p /etc/systemd/system/docker.service.d
    echo "[Service]" > /etc/systemd/system/docker.service.d/http-proxy.conf
    echo "Environment=\"HTTP_PROXY=$PROXY_HOST:$PROXY_PORT\"" >> /etc/systemd/system/docker.service.d/http-proxy.conf
    echo "Environment=\"HTTPS_PROXY=$PROXY_HOST:$PROXY_PORT\"" >> /etc/systemd/system/docker.service.d/http-proxy.conf
    systemctl daemon-reload
    systemctl restart docker

    # Apt-Proxy setzen
    echo "Acquire::http::Proxy \"$PROXY_HOST:$PROXY_PORT\";" > /etc/apt/apt.conf.d/99proxy
}

# Funktion zum Entfernen des Proxys
remove_proxy() {
    unset http_proxy
    unset https_proxy
    unset ftp_proxy

    # Docker-Proxy entfernen
    rm -f /etc/systemd/system/docker.service.d/http-proxy.conf
    systemctl daemon-reload
    systemctl restart docker

    # Apt-Proxy entfernen
    rm -f /etc/apt/apt.conf.d/99proxy
}

# Hauptfunktion
main() {
    # Konfiguration lesen
    read_config

    # Ping-Check
    ping -c 1 "$PING_HOST" > /dev/null

    if [ $? -eq 0 ]; then
        echo "Der Host ist erreichbar. Proxy wird gesetzt."
        set_proxy
    else
        echo "Der Host ist nicht erreichbar. Proxy wird entfernt."
        remove_proxy
    fi
}

# Hauptprogramm
main
