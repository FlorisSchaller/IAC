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

echo "Wat voor omgeving mag er verwijderd worden? (Prod/Acc/Test/Dev)"
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

echo "Weet je zeker dat je de omgeving ${klantnaam}-${klantomgeving} wilt verwijderen? (y/n)"
read bevestiging

if [[ "$bevestiging" == "y" ]]; then
    cd "$klantdir" && vagrant destroy -f
    cd ..
    rm -rf "$klantdir"
    echo "Omgeving ${klantnaam}-${klantomgeving} is verwijderd."
else
    echo "Verwijdering gestopt!"
fi

