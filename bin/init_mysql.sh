#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"
readonly PROJECT_HOME="${SCRIPT_DIR}/.."

readonly MYSQL_DATABASE='mydb'
readonly MYSQL_USER='myuser'
readonly MYSQL_PASSWORD='mypassword'
readonly DDL_FILE_IN_CONTAINER='/sqls/0.ddl.sql'
readonly INSERT_FILE_IN_CONTAINER='/sqls/1.insert.sql'
readonly INSERT_FILE_IN_HOST="${PROJECT_HOME}/dependencies/mysql/sqls/1.insert.sql"

cd "${PROJECT_HOME}/dependencies/mysql"
yarn install
echo 'Generating data...'
node data-generator.js > "${INSERT_FILE_IN_HOST}"

cd "${PROJECT_HOME}"

echo 'Dropping database...'
docker-compose exec \
  -e MYSQL_PWD="${MYSQL_PASSWORD}" \
  mysql \
  mysql -u"${MYSQL_USER}" "${MYSQL_DATABASE}" \
  -e 'drop database mydb; create database mydb;'

echo 'Loading DDL...'
docker-compose exec \
  -e MYSQL_PWD="${MYSQL_PASSWORD}" \
  mysql \
  bash -c \
    "mysql -u"${MYSQL_USER}" "${MYSQL_DATABASE}" < "${DDL_FILE_IN_CONTAINER}""

echo 'Loading insert...'
docker-compose exec \
  -e MYSQL_PWD="${MYSQL_PASSWORD}" \
  mysql \
  bash -c \
    "mysql -u"${MYSQL_USER}" "${MYSQL_DATABASE}" < "${INSERT_FILE_IN_CONTAINER}""
