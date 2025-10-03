#!/usr/bin/env bash

# Exit on error
set -e

bash wget-curl.sh
bash nmap.sh
bash git.sh
bash trash.sh

bash github.sh
bash languages.sh
