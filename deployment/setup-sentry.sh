#!/bin/bash

if hash sentry-cli 2>/dev/null ; then
	if [ -z $SENTRY_DSN ]; then
		echo "Sentry is installed but no Sentry DSN is configured."
		exit 3
	fi
	echo "Sentry is enabled."
	function setup_error_handling() {
		sentry-cli bash-hook
	}
else
	echo "sentry-cli not installed, errors won't be sent to the server"
	function setup_error_handling() {
		echo ''
	}
fi
export setup_error_handling

