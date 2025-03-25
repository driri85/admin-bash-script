#!/bin/bash
while true; do
    clear
    echo "=== MENU PRINCIPAL ==="
    echo "1: Surveiller les ressources"
    echo "2: Gérer les utilisateurs"
    echo "3: Vérifier/Mise à jour du système"
    echo "4: Gérer le pare-feu"
    echo "5: Quitter"
    read -p "Choisissez une option (1-5) : " choix
    case $choix in
        1)
            echo "=== SURVEILLANCE DES RESSOURCES ==="
            echo "1: CPU"
            echo "2: RAM"
            echo "3: Stockage"
            echo "4: Réseau"
            read -p "Choisissez une option (1-4) : " ressource
            case $ressource in
                1) lscpu | grep -E "Model name|CPU MHz|Socket|Core|Thread" ;;
                2) free -h ;;
                3) df -h ;;
                4) ip -br addr show ;;
                *) echo "Option invalide." ;;
            esac
            read -p "Appuyez sur Entrée pour continuer..."
            ;;
        
        2)
            echo "=== GESTION DES UTILISATEURS ==="
            echo "1: Ajouter un utilisateur"
            echo "2: Supprimer un utilisateur"
            echo "3: Modifier permissions (sudo)"
            read -p "Choisissez une option (1-3) : " user_choice
            case $user_choice in
                1) 
                    read -p "Nom de l'utilisateur à ajouter: " username
                    sudo adduser "$username"
                    ;;
                2) 
                    read -p "Nom de l'utilisateur à supprimer: " username
                    sudo deluser "$username"
                    ;;
                3) 
                    read -p "Nom de l'utilisateur : " username
                    echo "1: Ajouter à sudo"
                    echo "2: Retirer de sudo"
                    read -p "Choisissez (1-2) : " perm
                    if [[ $perm == "1" ]]; then
                        sudo usermod -aG sudo "$username"
                        echo "Ajouté à sudo."
                    elif [[ $perm == "2" ]]; then
                        sudo deluser "$username" sudo
                        echo "Supprimé de sudo."
                    else
                        echo "Option invalide."
                    fi
                    ;;
                *) echo "Option invalide." ;;
            esac
            read -p "Appuyez sur Entrée pour continuer..."
            ;;
        
        3)
            echo "=== SYSTEME ==="
            echo "1: Mettre à jour le système"
            echo "2: Afficher les informations système"
            read -p "Choisissez (1-2) : " sys_choice
            case $sys_choice in
                1) 
                    sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
                    echo "Mise à jour terminée."
                    ;;
                2) 
                    cat /etc/os-release
                    uname -r
                    ;;
                *) echo "Option invalide." ;;
            esac
            read -p "Appuyez sur Entrée pour continuer..."
            ;;
        
        4)
            echo "=== GESTION DU PARE-FEU ==="
            echo "1: Activer UFW"
            echo "2: Désactiver UFW"
            echo "3: Ajouter une règle UFW"
            echo "4: Supprimer une règle UFW"
            read -p "Choisissez (1-4) : " fw_choice
            case $fw_choice in
                1) sudo ufw enable ;;
                2) sudo ufw disable ;;
                3) 
                    read -p "Entrez la règle (ex: allow 22/tcp): " rule
                    sudo ufw $rule
                    ;;
                4) 
                    sudo ufw status numbered
                    read -p "Numéro de la règle à supprimer: " rule_num
                    sudo ufw delete $rule_num
                    ;;
                *) echo "Option invalide." ;;
            esac
            read -p "Appuyez sur Entrée pour continuer..."
            ;;
        
        5)
            echo "Au revoir !"
            exit 0
            ;;
        
        *)
            echo "Option invalide, réessayez."
            ;;
    esac
done
