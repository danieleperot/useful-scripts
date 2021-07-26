#!/usr/bin/zsh

current_dir=$PWD
red_bold="\e[1;91m"
red="\e[91m"
yellow="\e[93m"
green="\e[92m"
cyan="\e[96m"
reset_color="\e[0;39m"

function fancy_print {
	echo -ne "\t$1$2${reset_color} $3\n"
}

function warning {
	fancy_print $yellow $1 $2
}

function ok {
	fancy_print $green $1 $2
}

function info {
	fancy_print $cyan $1 $2
}

function error {
	fancy_print $red $1 $2
}

function check_git_origin {
	origin=$(git remote)
	if [ -z origin  ]; then
		warning "Branch[0;39m Esci\n\t\e[96m\t?:\e[0;39m Stampa\n\e[1;91mws-sdk\e[0;39m\t\n\t\e[93mws-sdk\e[0;39m non\n\t\e[93mNessuna\e[0;39m cartella\n\t\e[96mQuale\e[0;39m azione\n\t\e[96m\ts:\e[0;39m Salta\n\t\e[96m\td:\e[0;39m Elimina\n\t\e[96m\tc:\e[0;39m Vai\n\t\e[96m\tq:\e[0;39m Esci\n\t\e[96m\t?:\e[0;39m Stampa\n\e[1;91mioinformatica\e[0;39m\t\n\t\e[93mioinformatica\e[0;39m non\n\t\e[93mNessuna\e[0;39m cartella\n\t\e[96mQuale\e[0;39m azione\n\t\e[96m\ts:\e[0;39m Salta\n\t\e[96m\td:\e[0;39m Elimina\n\t\e[96m\ remoto non impostato"
	else
		ok "Branch remoto impostato"
	fi
}

function check_git_status {
	dirty=$(git status -s | wc -l)
	if [ $dirty -ne 0  ]; then
		warning "File git non committati:" $dirty
	else
		ok "Tutti i file git committati"
	fi
}

function delete_folder {
	warning "\n\t${1} verrà rimosso in 3 secondi. Premere CTRL+C per annullare."
	sleep 3
	warning "Eliminazione in corso..."
	rm -rf "$1" > /dev/null 2>&1
	if [ $? -ne 0 ]; then
        echo
        error "Impossibile rimuovere completamente la risorsa. Ritentare cercando di sistemare i permessi? (y|n)"
        read -q response
        if [[ $response == "y" ]]; then
            info "Sarà richiesta la password per effettuare il cambio dei permessi"
            sudo chown -R $USER:$USER $1
            ok "Permessi impostati"
            delete_folder $1
        else
            info "La risorsa non verrà eliminata"
        fi
    else
	    ok "Rimozione competata!"
    fi
}

function prompt_delete {
	error "Vuoi davvero elminare la risorsa? (y, n) "
	read -q -s response
	if [[ $response == "y" ]]; then
		delete_folder $1
	else
		ok "La risorsa non verrà eliminata"
	fi
	echo
}

function prompt_action {
    echo
    info "Quale azione vuoi eseguire?" "(s,d,l,q,?)"
    read -k 1 -s answer

    if [[ $answer == "s" ]]; then
        ok "Skipping..."
        return
    elif [[ $answer == "d" ]]; then
        prompt_delete $1
    elif [[ $answer == "l" ]]; then
        ls -Alh $1
        prompt_action
    elif [[ $answer == "q" ]]; then
        exit
    else
        info "\ts: Salta"
        info "\td: Elimina"
        info "\td: Visualizza file"
        info "\tc: Vai alla cartella"
        info "\tq: Esci"
        info "\t?: Stampa questo aiuto"
        prompt_action
    fi
}

cd ~/code

ls -1 | while read -r line
do
	echo -ne "${red_bold}${line}${reset_color}\t\n"

    if [ -d ~/code/$line ]; then    
	    cd ~/code/$line
    else
        warning "$line non è una cartella"
    fi

	if [ -d ".git" ]; then
		ok "Nel branch:" $(git branch --show-current)
		check_git_origin
		check_git_status
	else
		warning "Nessuna cartella git trovata"
	fi

	cd ~/code
	
	prompt_action ~/code/$line
done
