#!/bin/bash

function idea() {
	intellij-idea-community $1 </dev/null &>/dev/null &
}
