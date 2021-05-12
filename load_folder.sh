#!/usr/bin/zsh

function main_echo {
  echo "**********************************"
  echo "*        CHECKING PROJECT        *"
  echo "*              by Daniele Perot  *"
  echo "**********************************"
}

function is_running {
  container=`$1 ps -q | wc -l`
  if [[ $container -eq 0 ]]; then
    return 1
  else
    return 0
  fi
}

function node_echo {
  echo -ne "Node environment found: $(cat .nvmrc)\n"
}

function load_node {
  if test -f ".nvmrc"; then
    if [[ $(cat .nvmrc) != *$(node -v)* ]]; then
        echo -ne "$fg[yellow]\u2742 $reset_color\t"
	node_echo
	echo $fg[015]
	nvm use || nvm install
	echo $reset_color
    else
        echo -ne "$fg[green]\u2742 $reset_color\t"
	node_echo
    fi
  fi
}

function load_vessel {
  if test -f "vessel"; then
	color='red'
	if is_running ./vessel; then
	  color='green'
	fi
    echo -ne "$fg[$color]\u2742 $reset_color\tVessel found\n"
  fi
}

function load_kayak {
  if test -f "kayak"; then
	color='red'
	if is_running ./kayak; then
	  color='green'
	fi
    echo -ne "$fg[$color]\u2742 $reset_color\tKayak found\n"
  fi
}

function load_docker_compose {
  if test -f "kayak"; then
    return
  fi

  if test -f "vessel"; then
    return
  fi

  if test -f "docker-compose.yml"; then
	color='red'
	if is_running docker-compose; then
	  color='green'
	fi
    echo -ne "$fg[yellow]\u2742 $reset_color\tDocker Compose found\n"
  fi
}

function load_all {
  # load_vessel
  # load_kayak
  # load_docker_compose
  load_node
}

function chpwd {
  load_all
}

# main_echo
load_all
