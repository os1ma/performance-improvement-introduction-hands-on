#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

readonly MYSQL_DATABASE='mydb'
readonly MYSQL_USER='myuser'
readonly MYSQL_PASSWORD='mypassword'

readonly SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"
readonly PROJECT_HOME="${SCRIPT_DIR}/.."

cd "${PROJECT_HOME}"
docker-compose exec mysql mysql -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}"
