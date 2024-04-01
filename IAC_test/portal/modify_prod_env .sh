#!/bin/bash

echo "Voer de klantnaam in:"
read klantnaam
klantdir="./${klantnaam}-prod"

if [ ! -d "$klantdir" ]; then
    echo "De opgegeven omgeving bestaat niet."
    exit 1
fi

# Hier zou je aanvullende wijzigingen kunnen toepassen, afhankelijk van de omgeving
echo "Voer de wijzigingen uit op de omgeving ${klantnaam}-prod."

# Voorbeeld van een eenvoudige wijziging: het RAM-geheugen aanpassen
echo "Hoeveel RAM-geheugen moet de machine krijgen? (in MB)"
read new_ram

# Update de Vagrantfile (dit vereist dat je Vagrantfile een marker of specifieke syntax gebruikt die je kunt zoeken en vervangen)
sed -i "/vb.memory =/c\      vb.memory = \"$new_ram\"" "${klantdir}/Vagrantfile"

echo "RAM-geheugen is bijgewerkt naar $new_ram MB. Uitvoeren van 'vagrant reload' om de wijzigingen toe te passen..."

# Herlaad de VM om de wijzigingen toe te passen
cd ${klantdir}/
vagrant reload

echo "De omgeving voor ${klantnaam}-prod is bijgewerkt."

