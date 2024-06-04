#!/bin/bash

#########################################################
# 							#
#	Dit bestand is gemaakt door Floris Schaller	#
# 	Naam:		Floris Schaller			#
# 	Studentnummer: 	S1168815			#
# 	Email:		floris.schaller@windesheim.ml	#
#							#
#########################################################

echo "Voer de klantnaam in:"
read klantnaam

echo "Wat voor omgeving mag er gewijzigd worden? (Prod/Acc/Test/Dev)"
read klantomgeving

if [[ ! ${klantomgeving} =~ ^(Prod|Acc|Test|Dev)$ ]]; then
    echo "Onjuiste waarde. Kies uit Prod, Acc, Test of Dev."
    exit 1
    fi

klantdir="/home/student/IAC_test/${klantnaam}-${klantomgeving}"

if [ ! -d "$klantdir" ]; then
    echo "De opgegeven omgeving bestaat niet."
    exit 1
fi

# Hier zou je aanvullende wijzigingen kunnen toepassen, afhankelijk van de omgeving
echo "Voer de wijzigingen uit op de omgeving ${klantnaam}-${klantomgeving}"

# Voorbeeld van een eenvoudige wijziging: het RAM-geheugen aanpassen
echo "Hoeveel RAM-geheugen moet de machine krijgen? (in MB)"
read new_ram

# Update de Vagrantfile (dit vereist dat je Vagrantfile een marker of specifieke syntax gebruikt die je kunt zoeken en vervangen)
sed -i "/vb.memory =/c\      vb.memory = \"$new_ram\"" "${klantdir}/Vagrantfile"

echo "Het RAM geheugen is bewerkt naar $new_ram MB. Nu start 'vagrant reload' om de wijzigingen door te voeren"

# Herlaad de VM om de wijzigingen toe te passen
cd ${klantdir}/
vagrant destroy

vagrant up

echo "De omgeving voor ${klantnaam}-${klantomgeving} is aangepast."
