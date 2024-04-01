#!/bin/bash

echo "Voer de klantnaam in:"
read klantnaam
klantdir="./${klantnaam}-prod"

if [ ! -d "$klantdir" ]; then
    echo "De opgegeven omgeving bestaat niet."
    exit 1
fi

echo "Weet je zeker dat je de omgeving ${klantnaam}-prod wilt verwijderen? Dit kan niet ongedaan gemaakt worden. (y/n)"
read bevestiging

if [[ "$bevestiging" == "y" ]]; then
    cd "$klantdir" && vagrant destroy -f
    cd ..
    rm -rf "$klantdir"
    echo "Omgeving ${klantnaam}-prod is verwijderd."
else
    echo "Verwijdering geannuleerd."
fi

