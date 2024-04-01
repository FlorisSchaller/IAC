#!/bin/bash

echo "Welkom bij het VM-beheerscript!"

echo "Kies een optie:"
select optie in "Nieuwe omgeving aanmaken" "Omgeving wijzigen" "Omgeving verwijderen" "Afsluiten"; do
    case $optie in
        "Nieuwe omgeving aanmaken")
            echo "Kies het type omgeving dat je wilt aanmaken:"
            select omgevingstype in "Testomgeving" "Productieomgeving"; do
                case $omgevingstype in
                    "Testomgeving")
                        ./create_test_env.sh
                        break 2
                        ;;
                    "Productieomgeving")
                        ./create_prod_env.sh
                        break 2
                        ;;
                    *)
                        echo "Ongeldige selectie."
                        ;;
                esac
            done
            ;;
        "Omgeving wijzigen")
	        echo "Kies het type omgeving dat je wilt wijzigen:"
            select omgevingstype in "Testomgeving" "Productieomgeving"; do
                case $omgevingstype in
                    "Testomgeving")
                        ./modify_test_env.sh
                        break 2
                        ;;
                    "Productieomgeving")
                        ./modify_prod_env.sh
                        break 2
                        ;;
                    *)
                        echo "Ongeldige selectie."
                        ;;
                esac
            done
            ;;
        "Omgeving verwijderen")
            echo "Kies het type omgeving dat je wilt verwijderen:"
            select omgevingstype in "Testomgeving" "Productieomgeving"; do
                case $omgevingstype in
                    "Testomgeving")
                        ./delete_test_env.sh
                        break 2
                        ;;
                    "Productieomgeving")
                        ./delete_prod_env.sh
                        break 2
                        ;;
                    *)
                        echo "Ongeldige selectie."
                        ;;
                esac
            done
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

