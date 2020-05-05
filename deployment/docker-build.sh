#!/bin/bash

source deployment/setup-sentry.sh
eval "$(setup_error_handling)"

docker build -t gambero -f deployment/Dockerfile .
