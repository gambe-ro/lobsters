#!/bin/bash

source deployment/setup-sentry.sh
eval "$(setup_error_handling)"

function check_env_vars () {
  for name; do
    : ${!name:?$name must not be empty}
  done
}

if [ $RAILS_ENV = "production" ]; then

	if [ ! -f .env ]; then
		echo 'A .env file must be present.'
		exit 2
	fi

	if ! check_env_vars "RAILS_ENV" "SECRET_KEY_BASE" "MYSQL_ROOT_PASSWORD" "MYSQL_USER" "MYSQL_PASSWORD" "MYSQL_DATABASE" "SMTP_USERNAME" "SMTP_PASSWORD"; then
		echo 'Some variables are not set in .env, please refer to deployment/check-env.sh for the list'
		exit 4
	fi

else
	echo 'Running in development mode, enviroment will not be checked'
fi


