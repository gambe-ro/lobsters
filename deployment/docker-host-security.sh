#!/bin/bash

source deployment/setup-sentry.sh
eval "$(setup_error_handling)"

if [ "$RAILS_ENV" = "production" ]; then
	if [ "$DOCKER_CONTENT_TRUST" != "1" ]; then
		echo '$DOCKER_CONTENT_TRUST should be set to 1.'
		echo "If you're using a CLI, add 'export DOCKER_CONTENT_TRUST=1' to .bashrc and rerun your command in a new shell."
		exit 1;
	else
		echo 'Content Trust ok'
	fi
else
	echo 'Running in development mode, no content trust'
fi

rm -rfv log
echo "GAMBERO_PATH=${GAMBERO_PATH:-/data (default value)}"
if [ $(stat -c %a "${GAMBERO_PATH:-/data}/log/") != 777 ]; then
	echo "${GAMBERO_PATH:-/data}/log/ should have 777 permissions (chmod -R 777 ${GAMBERO_PATH:-/data}/log/)."
	echo "Trying to fix automatically..."
	chmod -v 777 "${GAMBERO_PATH:-/data}/log/"
else
	echo "${GAMBERO_PATH:-/data}/log/ permissions ok"
fi
if [ $(stat -c %a "${GAMBERO_PATH:-/data}/sphinx/") != 777 ]; then
	echo "${GAMBERO_PATH:-/data}/sphinx/ should have 777 permissions (chmod -R 777 ${GAMBERO_PATH:-/data}/sphinx/)."
	echo "Trying to fix automatically..."
	chmod -v 777 "${GAMBERO_PATH:-/data}/sphinx/"
else
	echo "${GAMBERO_PATH:-/data}/sphinx/ permissions ok"
fi
mkdir -pv tmp/
chmod -Rv 777 tmp/
mkdir -pv public/assets/
chmod -Rv 777 public/assets/
chmod -v a+rw db/schema.rb
# Not related to security, but worth putting here. Saves some headaches.
# https://github.com/instructure/canvas-lms/issues/1221#issuecomment-362690811
chmod -v a+w Gemfile.lock