#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

readonly MYSQL_DATABASE='mydb'
readonly MYSQL_USER='myuser'
readonly MYSQL_PASSWORD='mypassword'
readonly DDL_FILE_IN_CONTAINER='/docker-entrypoint-initdb.d/0.ddl.sql'
readonly INSERT_FILE_IN_CONTAINER='/docker-entrypoint-initdb.d/1.insert.sql'

readonly SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"
readonly PROJECT_HOME="${SCRIPT_DIR}/.."

cd "${PROJECT_HOME}/mysql"
yarn install
echo 'Generating data...'
node data-generator.js > docker-entrypoint-initdb.d/1.insert.sql

cd "${PROJECT_HOME}"

echo 'Dropping database...'
docker-compose exec mysql \
  mysql -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" \
  -e 'drop database mydb; create database mydb;'

echo 'Loading DDL...'
docker-compose exec mysql \
  bash -c \
    "mysql -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" < "${DDL_FILE_IN_CONTAINER}""

echo 'Loading insert...'
docker-compose exec mysql \
  bash -c \
    "mysql -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" < "${INSERT_FILE_IN_CONTAINER}""
