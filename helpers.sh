################################################################################
# This file provides helper functions for smalltalkCI. It is used in the context
# of a smalltalkCI build and it is not meant to be executed by itself.
################################################################################

readonly BUILD_STATUS_FILE="${SMALLTALK_CI_BUILD}/build_status.txt"
readonly GITHUB_API="https://api.github.com"
readonly COVERALLS_API="https://coveralls.io/api/v1/jobs"
readonly COVERALLS_OPTIONAL_KEYS="flag_name parallel repo_token service_job_id
  service_job_number service_name service_number service_pull_request"
readonly JQ_BASE_URL="https://github.com/stedolan/jq/releases/download/jq-1.6"
jq_binary=""

readonly ANSI_BOLD="\033[1m"
readonly ANSI_RED="\033[31m"
readonly ANSI_GREEN="\033[32m"
readonly ANSI_YELLOW="\033[33m"
readonly ANSI_BLUE="\033[34m"
readonly ANSI_RESET="\033[0m"
readonly ANSI_CLEAR="\033[0K"

print_info() {
  if is_colorful; then
    printf "${ANSI_BOLD}${ANSI_BLUE}%s${ANSI_RESET}\n" "$1"
  else
    echo "$1"
  fi
}

print_notice() {
  if is_colorful; then
   printf "${ANSI_BOLD}${ANSI_YELLOW}%s${ANSI_RESET}\n" "$1"
  else
    echo "$1"
  fi
}

print_success() {
  if is_colorful; then
   printf "${ANSI_BOLD}${ANSI_GREEN}%s${ANSI_RESET}\n" "$1"
  else
    echo "$1"
  fi
}

print_error() {
  if is_colorful; then
   printf "${ANSI_BOLD}${ANSI_RED}%s${ANSI_RESET}\n" "$1" 1>&2
  else
    echo "$1" 1>&2
  fi
}

print_error_and_exit() {
  print_error "$1"
  exit "${2:-1}" # 2nd parameter, 1 if not set
}

print_help() {
  cat <<EOF
  USAGE: $(basename -- $0) [options] /path/to/project/your_smalltalk.ston

  This program prepares Smalltalk images/vms, loads projects, and runs tests.

  OPTIONS:
    --clean                 Clear cache and delete builds.
    -d | --debug            Enable debug mode.
    --force-cache           Force use of the cache for all images (overrides '--overwrite-cache').
    -h | --help             Show this help text.
    --headful               Open vm in headful mode and do not close image.
    --image                 Custom image for build (Squeak/Pharo).
    --install               Install symlink to this smalltalkCI instance.
    --overwrite-cache   Download the newest image and cache it.
    --print-env             Print all environment variables used by smalltalkCI
    --no-color              Disable colored output
    --no-tracking           Disable collection of anonymous build metrics (Travis CI & AppVeyor only).
    -s | --smalltalk        Overwrite Smalltalk image selection.
    --uninstall             Remove symlink to any smalltalkCI instance.
    -v | --verbose          Enable 'set -x'.
    --vm                    Custom VM for build (Squeak/Pharo).

  GEMSTONE OPTIONS:
    --gs-DEBUG              Enable remote debugging of GsDevKit_stones .solo scripts
                            via topaz DEBUGGEM command.

    --gs-PRODUCTS=<gemstone-product-directory>
                            Specify directory containing GemStone product downloads
                            to be used instead of downloading products from 
                            https://ftp.gemtalksystems.com for each run.

    --gs-REPOS=<gemstone-server-git-projects>
                            Specify directory containing existing server projects to be 
                            used instead of cloning projects from GitHub for each run.

    --gs-STONE_DIR=<gemstone-stone-directory>
                            Specify directory of an existing stone. A symbolic link named
                            product is expected to exist in the <gemstone-stone-directory>
                            and point to the GEMSTONE product tree for the stone. The name
                            stone is expected to be managed independently of the run.sh
                            script. 

  EXAMPLE:
    $(basename -- $0) -s "Squeak64-trunk" --headfull /path/to/project/.smalltalk.ston

EOF
}

print_config() {
  for var in ${!config_@}; do
    echo "${var}=${!var}"
  done
}

print_env() {
  env | grep "SMALLTALK_CI_"
}

is_colorful() {
  [[ "${config_colorful:-true}" == "true" ]]
}

is_empty() {
  local var=$1

  [[ -z $var ]]
}

is_not_empty() {
  local var=$1

  [[ -n $var ]]
}

is_file() {
  local file=$1

  [[ -f $file ]]
}

is_dir() {
  local dir=$1

  [[ -d $dir ]]
}

is_nonzero() {
  local status=$1

  [[ "${status}" -ne 0 ]]
}

is_int() {
  local value=$1

  [[ $value =~ ^-?[0-9]+$ ]]
}

program_exists() {
  command -v "$1" &> /dev/null
}

is_travis_build() {
  [[ "${TRAVIS:-}" = "true" ]]
}

is_appveyor_build() {
  [[ "${APPVEYOR:-}" = "True" ]]
}

is_github_build() {
  [[ "${GITHUB_ACTIONS:-}" = "true" ]]
}

is_gitlabci_build() {
  [[ "${GITLAB_CI:-}" = "true" ]]
}

is_linux_build() {
  [[ $(uname -s) = "Linux" ]]
}

is_cygwin_build() {
  [[ $(uname -s) = "CYGWIN_NT-"* ]]
}

is_mingw64_build() {
  [[ $(uname -s) = "MINGW64_NT-"* ]]
}

is_msys2_build() {
  [[ $(uname -s) = "MSYS_NT-"* ]]
}

is_mac_build() {
  [[ $(uname -s) = "Darwin" ]]
}

is_windows_build() {
  is_cygwin_build ] || is_mingw64_build || is_msys2_build
}

hardware_platform() {
  echo "$(uname -m)"
}

is_sudo_enabled() {
  $(sudo -n true > /dev/null 2>&1)
}

is_trunk_build() {
  case "${config_smalltalk}" in
    *"trunk"|*"Trunk"|*"latest"|*"Latest")
      return 0
      ;;
  esac
  return 1
}

image_is_user_provided() {
  is_not_empty "${config_image}"
}

vm_is_user_provided() {
  is_not_empty "${config_vm}"
}

is_64bit() {
  [[ "${config_smalltalk}" == *"64-"* ]]
}

is_spur_image() {
  local image_path=$1
  local image_format_number
  # "[...] bit 5 of the format number identifies an image that requires Spur
  # support from the VM [...]"
  # http://forum.world.st/VM-Maker-ImageFormat-dtl-17-mcz-td4713569.html
  local spur_bit=5

  if is_empty "${image_path}"; then
    print_error "Image not found at '${image_path}'."
    return 0
  fi

  if hash hexdump 2>/dev/null; then
    image_format_number="$(hexdump -n 4 -e '2/4 "%04d " "\n"' "${image_path}")"
  elif hash xxd 2>/dev/null; then
    image_format_number="$((16#$(xxd -p -l 1 "${image_path}")))"
  else
    print_error_and_exit "Unable to detect image format (xxd or hexdump needed)"
  fi

  [[ $((image_format_number>>(spur_bit-1) & 1)) -eq 1 ]]
}

is_headless() {
  [[ "${config_headless}" = "true" ]]
}

is_git_repo() {
  if ! git --no-pager log -1 > /dev/null 2>&1; then
    return 1
  fi
  return 0
}

starts_with() {
  [[ "$1" == "$2"* ]]
}

ston_includes_loading() {
  grep -Fq "#loading" "${config_ston}"
}

debug_enabled() {
  [[ "${config_debug}" = "true" ]]
}

signals_error() {
  [[ $1 != "[success]" ]]
}

current_build_status_signals_error() {
  if ! is_file "${BUILD_STATUS_FILE}"; then
    print_error "Build was unable to report intermediate build status."
    return 0
  fi
  if signals_error "$(cat "${BUILD_STATUS_FILE}")"; then
    return 0
  fi
  return 1
}

consume_build_status_file() {
  rm -f "${BUILD_STATUS_FILE}"
}

check_and_consume_build_status_file() {
  local build_status

  if current_build_status_signals_error; then
    build_status="$(cat "${BUILD_STATUS_FILE}")"
    if [[ "${build_status}" == "[test failure]" ]]; then
      exit 1
    fi
    print_error_and_exit "${build_status}"
  fi
  consume_build_status_file
}

finalize() {
  local build_status

  if is_travis_build || is_appveyor_build || is_github_build; then
    upload_coveralls_results
  else
    print_info "Skipping coveralls upload."
  fi

  if ! is_file "${BUILD_STATUS_FILE}"; then
    print_error_and_exit "Build was unable to report final build status."
  fi
  build_status=$(cat "${BUILD_STATUS_FILE}")
  if is_travis_build; then
    deploy "${build_status}"
  fi
  if signals_error "${build_status}"; then
    if [[ "${build_status}" != "[test failure]" ]]; then
      print_error_and_exit "${build_status}"
    fi
    exit 1
  else
   exit 0
  fi
}

conditional_debug_halt() {
  if ! is_headless && debug_enabled; then
    printf "self halt.\n"
  fi
}

download_file() {
  local url=$1
  local target=$2

  if is_empty "${url}" || is_empty "${target}"; then
    print_error_and_exit "download_file() expects an URL and a target path."
  fi

  if program_exists "curl"; then
    curl --fail --silent --show-error --location \
      --retry 3 --retry-delay 5 --max-time 300 \
      -o "${target}" "${url}" || print_error_and_exit \
        "curl failed to download ${url} to '${target}'."
  elif program_exists "wget"; then
    wget -t 3 --retry-connrefused --waitretry=5 --read-timeout=20 --timeout=300 \
      --no-dns-cache -q -O "${target}" "${url}" || print_error_and_exit \
        "wget failed to download ${url} to '${target}'."
  else
    print_error_and_exit "Please install curl or wget."
  fi
}

extract_file() {
  local path=$1
  local target=$2

  if [[ "${path}" == *".tar.gz" ]]; then
    tar xzf "${path}" -C "${target}"
  elif [[ "${path}" == *".zip" ]]; then
    unzip "${path}" -d "${target}"
  elif [[ "${path}" == *".dmg" ]]; then
    readonly VOLUME=$(hdiutil attach "${path}" | tail -1 | awk '{print $3}')
    cp -R "${VOLUME}/"* "${target}/"
    diskutil unmount "${VOLUME}"
  fi
}

resolve_path() {
  local path=$1

  if is_cygwin_build || is_mingw64_build || is_msys2_build; then
    echo $(cygpath -w "${path}")
  else
    echo "${path}"
  fi
}

return_vars() {
  (IFS="|"; echo "$*")
}

set_vars() {
  local variables=(${@:1:(($# - 1))})
  local values="${!#}"

  IFS="|" read -r "${variables[@]}" <<< "${values}"
}

to_lowercase() {
  echo $1 | tr "[:upper:]" "[:lower:]"
}

ensure_jq_binary() {
  if ! is_empty "${jq_binary}"; then
    return 0
  elif program_exists "jq"; then
    jq_binary="jq"
    return 0
  fi
  jq_binary="${SMALLTALK_CI_HOME}/bin/jq"
  if ! is_file "${jq_binary}"; then
    case "$(uname -s)" in
      "Linux")
        download_file "${JQ_BASE_URL}/jq-linux64" "${jq_binary}"
        chmod +x "${jq_binary}"
        ;;
      "Darwin")
        download_file "${JQ_BASE_URL}/jq-osx-amd64" "${jq_binary}"
        chmod +x "${jq_binary}"
        ;;
      "CYGWIN_NT-"*|"MINGW64_NT-"*|"MSYS_NT-"*)
        download_file "${JQ_BASE_URL}/jq-win64.exe" "${jq_binary}"
        chmod +x "${jq_binary}"
        ;;
      *)
        print_error_and_exit "Unsupported platform '$(uname -s)'."
        ;;
    esac
  fi
}

git_log() {
  local format_value=$1
  echo "$(git --no-pager log -1 --pretty=format:"${format_value}" | "${jq_binary}" -Rs .)"
}

export_coveralls_data() {
  local branch_name="unknown"
  local flag_name="${COVERALLS_FLAG_NAME:-}"
  local optional_values=""
  local parallel="${COVERALLS_PARALLEL:-}"
  local repo_token=""
  local service_job_id=""
  local service_job_number=""
  local service_number=""
  local service_name=""
  local service_pull_request=""
  local url="unknown"


  if is_git_repo; then
    # This is a Git repository. We assume that it's the correct one.
    # pushd, so that popd doesn't change the directory later.
    pushd "$(pwd)"
  else
    # Change directory to the target project repository.
    # The assumption here is that the STON file resides within the
    # repository.
    if is_file "${config_ston}"; then
      pushd "$(dirname ${config_ston})" > /dev/null
    else
      print_error "Failed to find Git repository, can't determine commit information for the coverage report"
      return 0 # Proceed without coverage data
    fi
  fi

  if ! grep -q "#coverage" "${config_ston}"; then
    return 0 # Coverage data not needed
  fi

  # Handle info in same way as Coveralls' node module (see https://git.io/JJiOz)

  if is_not_empty "${COVERALLS_REPO_TOKEN:-}"; then
    print_info 'Using $COVERALLS_REPO_TOKEN instead of CI service info...'
    branch_name="$(git rev-parse --abbrev-ref HEAD)"
    repo_token="${COVERALLS_REPO_TOKEN:-}"
  elif is_travis_build; then
    branch_name="${TRAVIS_BRANCH}"
    service_job_id="${TRAVIS_JOB_ID}"
    service_name="travis-ci"
    service_pull_request="${TRAVIS_PULL_REQUEST:-}"
    url="https://github.com/${TRAVIS_REPO_SLUG}.git"
  elif is_appveyor_build; then
    branch_name="${APPVEYOR_REPO_BRANCH}"
    service_job_id="${APPVEYOR_BUILD_ID}"
    service_job_number="${APPVEYOR_BUILD_NUMBER}"
    service_name="appveyor"
    service_pull_request="${APPVEYOR_PULL_REQUEST_NUMBER:-}"
    url="https://github.com/${APPVEYOR_REPO_NAME}.git"
  elif is_gitlabci_build; then
    branch_name="${CI_COMMIT_REF_NAME}"
    service_job_id="${CI_BUILD_ID}"
    service_job_number="${CI_BUILD_NAME}"
    service_name="gitlab-ci"
    service_pull_request="${CI_MERGE_REQUEST_IID:-}"
    url="${CI_PROJECT_URL}"
  elif is_github_build; then
    if [[ "${GITHUB_REF}" == "refs/heads/"* ]]; then
      branch_name="${GITHUB_REF##*/}" # e.g. in push events.
    else
      branch_name="${GITHUB_HEAD_REF}" # e.g. in pull_request events.
    fi
    if is_empty "${GITHUB_TOKEN:-}"; then
      print_error_and_exit 'Running on GitHub Actions but $GITHUB_TOKEN is not set. Add `env: GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}` to your step config.'
    fi
    repo_token="${GITHUB_TOKEN}"
    service_name="github"
    service_number="${GITHUB_RUN_ID}"
    if [[ "${GITHUB_REF}" == "refs/pull/"* ]]; then
      service_pull_request="${GITHUB_REF#refs/pulls/}"
    fi
    url="https://github.com/${GITHUB_REPOSITORY}.git"
  fi

  for key in ${COVERALLS_OPTIONAL_KEYS}; do
    if is_not_empty "${!key:-}"; then
      optional_values="${optional_values}\"${key}\": \"${!key}\", "
    fi
  done

  ensure_jq_binary # required for git_log

  cat >"${SMALLTALK_CI_BUILD}/coveralls_build_data.json" <<EOL
{
  ${optional_values}
  "git": {
    "branch": "${branch_name}",
    "head": {
      "author_email": $(git_log "%ae"),
      "author_name": $(git_log "%aN"),
      "committer_email": $(git_log "%ce"),
      "committer_name": $(git_log "%cN"),
      "id": $(git_log "%H"),
      "message": $(git_log "%s") 
    },
    "remotes": [
      {
        "url": "${url}",
        "name": "origin"
      }
    ]
  }
}
EOL

popd > /dev/null
}

upload_coveralls_results() {
  local http_status=0
  local coverage_results="${SMALLTALK_CI_BUILD}/coveralls_results.json"
  local coveralls_response="${SMALLTALK_CI_BUILD}/coveralls_response"

  if is_file "${coverage_results}"; then
    print_info "Uploading coverage results to Coveralls..."
    http_status=$(curl -s -F json_file="@${coverage_results}" "${COVERALLS_API}" -o "${coveralls_response}" -w "%{http_code}" || echo $?)
    if [[ "${http_status}" != "200" ]]; then
      print_error "Failed to upload coverage results (HTTP status code #${http_status}):"
    fi
    if is_file "${coveralls_response}"; then
      cat "${coveralls_response}"
    fi
  fi
}

report_build_metrics() {
  local build_status=$1
  local env_name
  local project_slug
  local api_url
  local status_code
  local duration=$(($(timer_nanoseconds)-$smalltalk_ci_start_time))
  duration=$(echo "${duration}" | awk '{printf "%.3f\n", $1/1000000000}')

  if [[ "${config_tracking:-}" == "false" ]]; then
    return 0
  fi

  if is_travis_build; then
    env_name="TravisCI"
  elif is_appveyor_build; then
    env_name="AppVeyor"
  elif is_github_build; then
    env_name="GitHub"
  else
    return 0 # Only report build metrics when running on known CI service
  fi

  project_slug="${TRAVIS_REPO_SLUG:-${APPVEYOR_REPO_NAME:-${GITHUB_REPOSITORY:-}}}"
  api_url="${GITHUB_API}/repos/${project_slug}"
  status_code=$(curl -w %{http_code} -s -o /dev/null "${api_url}" || echo $?)
  if [[ "${status_code}" != "200" ]]; then
    return 0 # Not a public repository
  fi

  curl -s --header "X-BUILD-DURATION: ${duration}" \
          --header "X-BUILD-ENV: ${env_name}" \
          --header "X-BUILD-SMALLTALK: ${config_smalltalk:-unknown}" \
          --header "X-BUILD-STATUS: ${build_status}" \
            "https://smalltalkci.fniephaus.com/api/" > /dev/null || true
}

################################################################################
# Deploy build artifacts to bintray if configured.
################################################################################
deploy() {
  deploy_for_sorabito "$1"; return
  local build_status_value=$1
  local target
  local version="${TRAVIS_BUILD_NUMBER}"
  local project_name="$(basename ${TRAVIS_BUILD_DIR})"
  local name="${project_name}-${TRAVIS_JOB_NUMBER}-${config_smalltalk}"
  local image_name="${SMALLTALK_CI_BUILD}/${name}.image"
  local changes_name="${SMALLTALK_CI_BUILD}/${name}.changes"
  local publish=false

  if is_empty "${BINTRAY_CREDENTIALS:-}" || \
      [[ "${TRAVIS_PULL_REQUEST}" != "false" ]]; then
    return
  fi

  if ! signals_error "${build_status_value}"; then
    if is_empty "${BINTRAY_RELEASE:-}" || \
        [[ "${TRAVIS_BRANCH}" != "master" ]]; then
      return
    fi
    target="${BINTRAY_API}/${BINTRAY_RELEASE}/${version}"
    publish=true
  else
    if is_empty "${BINTRAY_FAIL:-}"; then
      return
    fi
    target="${BINTRAY_API}/${BINTRAY_FAIL}/${version}"
  fi

  fold_start deploy "Deploying to bintray.com..."
    pushd "${SMALLTALK_CI_BUILD}" > /dev/null

    print_info "Compressing and uploading image and changes files..."
    mv "${SMALLTALK_CI_IMAGE}" "${name}.image"
    mv "${SMALLTALK_CI_CHANGES}" "${name}.changes"
    tar czf "${name}.tar.gz" "${name}.image" "${name}.changes"
    curl -s -u "$BINTRAY_CREDENTIALS" -T "${name}.tar.gz" \
        "${target}/${name}.tar.gz" > /dev/null
    zip -q "${name}.zip" "${name}.image" "${name}.changes"
    curl -s -u "$BINTRAY_CREDENTIALS" -T "${name}.zip" \
        "${target}/${name}.zip" > /dev/null

    if signals_error "${build_status_value}"; then
      # Check for xml files and upload them
      if ls *.xml 1> /dev/null 2>&1; then
        print_info "Compressing and uploading debugging files..."
        mv "${TRAVIS_BUILD_DIR}/"*.fuel "${SMALLTALK_CI_BUILD}/" || true
        find . -name "*.xml" -o -name "*.fuel" | tar czf "debug.tar.gz" -T -
        curl -s -u "$BINTRAY_CREDENTIALS" \
            -T "debug.tar.gz" "${target}/" > /dev/null
      fi
    fi

    if "${publish}"; then
      print_info "Publishing ${version}..."
      curl -s -X POST -u "$BINTRAY_CREDENTIALS" "${target}/publish" > /dev/null
    fi

    popd > /dev/null
  fold_end deploy
}

deploy_for_sorabito() {
  local build_status_value=$1
  local target
  local version="${TRAVIS_BUILD_NUMBER}"
  local project_name="$(basename ${TRAVIS_BUILD_DIR})"
  local name="${project_name}-${TRAVIS_COMMIT}-${config_smalltalk}"
  local image_name="${SMALLTALK_CI_BUILD}/${name}.image"
  local changes_name="${SMALLTALK_CI_BUILD}/${name}.changes"
  local publish=false

  local sources_name=`ls "${SMALLTALK_CI_BUILD}" > >(grep sources)`
  print_info "${sources_name}"

  print_info "Deploy..."

  fold_start deploy "Deploying to ..."

    pushd "${SMALLTALK_CI_BUILD}" > /dev/null

    mv "${SMALLTALK_CI_IMAGE}" "${name}.image"
    mv "${SMALLTALK_CI_CHANGES}" "${name}.changes"

    touch "${TRAVIS_COMMIT}.REVISION"
    if [ -n "$sources_name" ]; then
      print_info "Compressing image, changes and sources files..."
      zip -q "travis-${name}.zip" "${name}.image" "${name}.changes" "${sources_name}" "${TRAVIS_COMMIT}.REVISION"
    else
      print_info "Compressing image and changes files..."
      zip -q "travis-${name}.zip" "${name}.image" "${name}.changes" "${TRAVIS_COMMIT}.REVISION"
    fi

    is_dir image || mkdir image
    cp "travis-${name}.zip" "image/travis-${name}.zip"
    cp -rf "travis-${name}.zip" "image/travis-${project_name}-lastSuccessfulBuild-${config_smalltalk}.zip"

    popd > /dev/null
  fold_end deploy
}

retry() {
  local retries=$1
  local command=$2
  local status=0

  $command || status=$?

  if [[ $status -ne 0 ]]; then
    if [[ $retries -gt 0 ]]; then
      echo "Retrying in one second..."
      sleep 1
      retry $(($retries - 1)) "$command"
    else
      print_error_and_exit "The command '${command}' failed too often (last exit code: ${status})."
    fi
  fi
}


################################################################################
# Travis-related helper functions (based on https://git.io/vzcTj).
################################################################################

timer_nanoseconds() {
  local cmd="date"
  local format="+%s%N"
  local os=$(uname)

  if hash gdate > /dev/null 2>&1; then
    cmd="gdate" # use gdate if available
  elif [[ "${os}" = Darwin ]]; then
    format="+%s000000000" # fallback to second precision on darwin (does not support %N)
  fi

  "$cmd" -u $format
}

run_script() {
  local timeout="${SMALLTALK_CI_TIMEOUT:-}"

  local cmd=( "$@" )

  if ! is_int "${timeout}"; then
    "${cmd[@]}"
    return $?
  fi

  "${cmd[@]}" &
  local cmd_pid=$!

  run_jigger $! "$timeout" "${cmd[@]}" &
  local jigger_pid=$!
  local result

  {
    wait $cmd_pid 2>/dev/null
    result=$?
    ps -p$jigger_pid &>/dev/null && kill $jigger_pid
  }

  if [ $result -ne 0 ]; then
    print_error_and_exit "The command ${cmd[*]} exited with $result."
  fi

  return $result
}

run_jigger() {
  # helper method for run_script()
  local cmd_pid=$1
  shift
  local timeout=$1 # in minutes
  shift
  local count=0

  while [ $count -lt $timeout ]; do
    count=$(($count + 1))
    echo -e "Still running ($count of $timeout): $@"
    sleep 60
  done

  if is_colorful; then
    echo -e "\n${ANSI_BOLD}${ANSI_RED}Timeout (${timeout} minutes) reached. Terminating \"$@\"${ANSI_RESET}\n"
  else
    echo -e "\nTimeout (${timeout} minutes) reached. Terminating \"$@\"\n"
  fi
  kill -9 $cmd_pid
}

fold_start() {
  local identifier=$1
  local title=$2

  timer_start_time=$(timer_nanoseconds)

  if is_travis_build; then
    local prefix="${SMALLTALK_CI_TRAVIS_FOLD_PREFIX:-}"
    travis_timer_id=$(printf %08x $(( RANDOM * RANDOM )))
    echo -en "travis_fold:start:${prefix}${identifier}\r${ANSI_CLEAR}"
    echo -en "travis_time:start:$travis_timer_id\r${ANSI_CLEAR}"
  fi
  if is_colorful; then
    echo -e "${ANSI_BOLD}${ANSI_BLUE}${title}${ANSI_RESET}"
  else
    echo -e "${title}"
  fi
}

fold_end() {
  local identifier=$1

  local timer_end_time=$(timer_nanoseconds)
  local duration=$(($timer_end_time-$timer_start_time))

  if is_travis_build; then
    local prefix="${SMALLTALK_CI_TRAVIS_FOLD_PREFIX:-}"
    echo -en "travis_time:end:$travis_timer_id:start=$timer_start_time,finish=$timer_end_time,duration=$duration\r${ANSI_CLEAR}"
    echo -en "travis_fold:end:${prefix}${identifier}\r${ANSI_CLEAR}"
  else
    duration=$(echo "${duration}" | awk '{printf "%.3f\n", $1/1000000000}')
    if is_colorful; then
      printf "${ANSI_RESET}${ANSI_BLUE} > Time to run: %ss${ANSI_RESET}\n" "${duration}"
    else
      printf " > Time to run: %ss\n" "${duration}"
    fi
  fi
}
