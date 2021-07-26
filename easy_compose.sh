#!/usr/bin/zsh

function start {
  if test -f "vendor/bin/sail"; then
    ./vendor/bin/sail up -d
    return
  fi

  if test -f "kayak"; then
    kayak start
    return
  fi

  if test -f "vendor/bin/sail"; then
    ./vendor/bin/sail up -d
    return
  fi

  if test -f "vessel"; then
    vessel start
    return
  fi

  docker-compose start
}

function stop {
  if test -f "vendor/bin/sail"; then
    ./vendor/bin/sail down
    return
  fi

  if test -f "kayak"; then
    kayak stop
    return
  fi

  if test -f "vendor/bin/sail"; then
    ./vendor/bin/sail stop
    return
  fi

  if test -f "vessel"; then
    vessel stop
    return
  fi

  docker-compose stop
}

function dps {
  if test -f "kayak"; then
    kayak ps
    return
  fi

  if test -f "vendor/bin/sail"; then
    ./vendor/bin/sail ps
    return
  fi

  if test -f "vessel"; then
    vessel ps
    return
  fi

  docker-compose ps
}

