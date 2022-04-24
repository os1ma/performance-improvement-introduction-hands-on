#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"
readonly PROJECT_HOME="${SCRIPT_DIR}/.."

cd "${PROJECT_HOME}"

initialize() {
  docker-compose down
  docker-compose up -d

  echo 'Wait for starting MySQL container...'
  sleep 60
  ./bin/init_mysql.sh
}

run_tests() {
  docker-compose exec ruby bash -c '
    cd exercises/ex01/ruby \
    && bundle install \
    && ruby main_test.rb
  '
}

cleanup() {
  docker-compose down
}

main() {
  initialize
  run_tests
  cleanup

  cat << EOT
==================
All Test Passed!!!
==================
EOT
}

main
