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

cd "${PROJECT_HOME}"

echo 'Generating data...'
docker-compose exec -T \
  node \
  bash -c \
    "cd ./dependencies/mysql && yarn install && node data-generator.js > ./sqls/1.insert.sql"

echo 'Dropping database...'
docker-compose exec -T \
  -e MYSQL_PWD="${MYSQL_PASSWORD}" \
  mysql \
  mysql -u"${MYSQL_USER}" "${MYSQL_DATABASE}" \
  -e 'drop database mydb; create database mydb;'

echo 'Loading DDL...'
docker-compose exec -T \
  -e MYSQL_PWD="${MYSQL_PASSWORD}" \
  mysql \
  bash -c \
    "mysql -u"${MYSQL_USER}" "${MYSQL_DATABASE}" < "${DDL_FILE_IN_CONTAINER}""

echo 'Loading Data...'
docker-compose exec -T \
  -e MYSQL_PWD="${MYSQL_PASSWORD}" \
  mysql \
  bash -c \
    "mysql -u"${MYSQL_USER}" "${MYSQL_DATABASE}" < "${INSERT_FILE_IN_CONTAINER}""

echo 'Generating expected values...'
docker-compose exec -T ruby bash -c "
  cd ./answers/ex01/ruby \
  && bundle install > /dev/null \
  && ruby main.rb
" > "${PROJECT_HOME}/expected/ex01.json"
docker-compose exec -T ruby bash -c "
  cd ./answers/ex02/ruby \
  && bundle install > /dev/null \
  && ruby main.rb
" > "${PROJECT_HOME}/expected/ex02.json"

cat << EOT
=================================
MySQL initialization succeeded!!!
=================================
EOT
