#!/bin/bash

# LIBRERIE NECESSARIE:
# sudo apt install libghc-yaml-dev jq

function validate-ci {
    if [ "$1" -eq  "0" ]; then
      CI_PATH=.gitlab-ci.yml
    else
      CI_PATH=$1
    fi

    echo "VALIDAZIONE GITLAB CI"
    echo "Percorso: $CI_PATH"

    # Prepare content for Gitlab API
    CONTENT=$(cat $CI_PATH | yaml2json - | tr -d '\n' | python -c 'import json,sys; print(json.dumps(sys.stdin.read()))')

    # Retrive results
    RESULT=$(curl -s --header "Content-Type: application/json" https://gitlab.com/api/v4/ci/lint --data "{\"content\": $CONTENT}")  

    # Get status
    STATUS=$(echo $RESULT | jq '.status' | sed "s/\"//g")

    echo
    if [[ "$STATUS" == "invalid" ]]; then
	echo "$fg[red]ERRORE$reset_color:"
	echo -ne "\t"
	echo -ne $RESULT | jq '.errors[0]' | sed "s/\"//g"
	echo -ne "\n"
    else
	echo "$fg[green]TUTTO OK$reset_color"
    fi
}


