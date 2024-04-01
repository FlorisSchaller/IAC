#!/bin/bash

echo "Voer de klantnaam in:"
read klantnaam
klantdir="./${klantnaam}-test"

if [ ! -d "$klantdir" ]; then
    echo "De opgegeven omgeving bestaat niet."
    exit 1
fi

echo "Weet je zeker dat je de omgeving ${klantnaam}-test wilt verwijderen? Dit kan niet ongedaan gemaakt worden. (y/n)"
read bevestiging

if [[ "$bevestiging" == "y" ]]; then
    cd "$klantdir" && vagrant destroy -f
    cd ..
    rm -rf "$klantdir"
    echo "Omgeving ${klantnaam}-test is verwijderd."
else
    echo "Verwijdering geannuleerd."
fi

