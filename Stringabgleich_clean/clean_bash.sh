#!/bin/bash

echo "== Debian Cleanup Script =="

# --- Paket-Cache aufräumen ---
echo "[1/3] Leere APT Cache..."
sudo apt clean
sudo apt autoclean

# --- Nicht mehr benötigte Pakete entfernen ---
echo "[2/3] Entferne ungenutzte Pakete..."
sudo apt autoremove -y

# --- Papierkorb löschen ---
echo "[3/3] Leere den Papierkorb..."
rm -rf ~/.local/share/Trash/*

echo "== Cleanup abgeschlossen! 🎉 =="

