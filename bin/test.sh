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

run_test() {
  local ex="$1"
  local runtime="$2"

  case "${runtime}" in
    'ruby')
      docker-compose exec ruby bash -c "
        cd "${ex}${runtime}" \
        && bundle install \
        && ruby main_test.rb
      "
      ;;
    'python')
      docker-compose exec python bash -c "
        cd "${ex}${runtime}" \
        && pip install -r requirements.txt \
        && python main_test.py
      "
      ;;
    'node')
      echo '[WARNING] Test for Node.js is not implemented.'
      ;;
    *)
      echo "Unexpected runtime '${runtime}'" >&2
      exit 1
      ;;
  esac
}

run_tests() {
  # exercises や answers
  local target_dir="$1"

  cd "${PROJECT_HOME}"

  # exercises/ex01 など、target_dir 以下のディレクトリ一覧を取得
  local exercises="$(ls -d "${target_dir}"/*/)"

  for ex in ${exercises[@]}; do
    cd "${PROJECT_HOME}/${ex}"

    # ruby/ などの、言語ごとのディレクトリ一覧を取得
    local runtime_dirs="$(ls -d */)"
    for runtime_dir in ${runtime_dirs[@]}; do

      # ruby などのランタイム名を取得
      local runtime="$(basename ${runtime_dir})"

      run_test "${ex}" "${runtime}"
    done
  done
}

cleanup() {
  docker-compose down
}

main() {
  initialize
  run_tests exercises
  run_tests answers
  cleanup

  cat << EOT
==================
All Test Passed!!!
==================
EOT
}

main
