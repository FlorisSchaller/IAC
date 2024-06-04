#!/bin/bash
#########################################################
# 							#
#	Dit bestand is gemaakt door Floris Schaller	#
# 	Naam:		Floris Schaller			#
# 	Studentnummer: 	S1168815			#
# 	Email:		floris.schaller@windesheim.ml	#
#							#
#########################################################

echo "Welkom bij het VM-beheerscript!"

echo "Kies een optie:"
select optie in "Nieuwe omgeving aanmaken" "Omgeving wijzigen" "Omgeving verwijderen" "Afsluiten"; do
    case $optie in
        "Nieuwe omgeving aanmaken")
        
        	./create_test_env.sh
       
            ;;
        "Omgeving wijzigen")
	        
            ./modify_test_env.sh

            ;;

        "Omgeving verwijderen")
            
            ./delete_test_env.sh

            ;;
        "Afsluiten")
            echo "Script wordt afgesloten."
            exit 0
            ;;
        *)
            echo "Ongeldige selectie."
            ;;
    esac
done

