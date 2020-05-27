#!/bin/bash

function is-available {
whois $1 | grep -q "AVAILABLE" \
	&& echo "LIBERO:   $fg[green]$1$reset_color" \
	|| echo "OCCUPATO: $fg[red]$1$reset_color"
}
