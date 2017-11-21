################################################################################
# This file provides helper functions for smalltalkCI. It is used in the context
# of a smalltalkCI build and it is not meant to be executed by itself.
################################################################################

readonly BUILD_STATUS_FILE="${SMALLTALK_CI_BUILD}/build_status.txt"
readonly GITHUB_API="https://api.github.com"
readonly COVERALLS_API="https://coveralls.io/api/v1/jobs"

readonly ANSI_BOLD="\033[1m"
readonly ANSI_RED="\033[31m"
readonly ANSI_GREEN="\033[32m"
readonly ANSI_YELLOW="\033[33m"
readonly ANSI_BLUE="\033[34m"
readonly ANSI_RESET="\033[0m"
readonly ANSI_CLEAR="\033[0K"

print_info() {
  printf "${ANSI_BOLD}${ANSI_BLUE}%s${ANSI_RESET}\n" "$1"
}

print_notice() {
  printf "${ANSI_BOLD}${ANSI_YELLOW}%s${ANSI_RESET}\n" "$1"
}

print_success() {
  printf "${ANSI_BOLD}${ANSI_GREEN}%s${ANSI_RESET}\n" "$1"
}

print_error() {
  printf "${ANSI_BOLD}${ANSI_RED}%s${ANSI_RESET}\n" "$1" 1>&2
}

print_error_and_exit() {
  local error_code="${2:-1}" # 2nd parameter, 1 if not set

  print_error "$1"
  report_build_metrics "${error_code}"
  exit "${error_code}"
}

print_help() {
  cat <<EOF
  USAGE: $(basename -- $0) [options] /path/to/project/your_smalltalk.ston

  This program prepares Smalltalk images/vms, loads projects, and runs tests.

  OPTIONS:
    --clean             Clear cache and delete builds.
    -d | --debug        Enable debug mode.
    -h | --help         Show this help text.
    --headful           Open vm in headful mode and do not close image.
    --image             Custom image for build (Squeak/Pharo).
    --install           Install symlink to this smalltalkCI instance.
    --no-tracking       Disable collection of anonymous build metrics (TravisCI & AppVeyor only).
    -s | --smalltalk    Overwrite Smalltalk image selection.
    --uninstall         Remove symlink to any smalltalkCI instance.
    -v | --verbose      Enable 'set -x'.
    --vm                Custom VM for build (Squeak/Pharo).

  GEMSTONE OPTIONS:
    --gs-BRANCH=<branch-SHA-tag>
                        Name of GsDevKit_home branch, SHA, or tag. Default is 'master'.

                        Environment variable GSCI_DEVKIT_BRANCH may be used to 
                        specify <branch-SHA-tag>. Command line option overrides 
                        value of environment variable.

    --gs-HOME=<GS_HOME-path>
                        Path to an existing GsDevKit_home clone to be used
                        instead of creating a fresh clone.

                        --gs-DEVKIT_BRANCH option is ignored.

    --gs-CLIENTS="<smalltalk-platform>..."
                        List of Smalltalk client versions to use as a GemStone client. 

                        Environment variable GSCI_CLIENTS may also be used to 
                        specify a list of <smalltalk-platform> client versions. 
                        Command line option overrides value of environment variable.

                        If a client is specified, tests are run for both the client 
                        and server based using the project .smalltalk.ston file.

  EXAMPLE:
    $(basename -- $0) -s "Squeak-trunk" --headfull /path/to/project/.smalltalk.ston

EOF
}

print_config() {
  for var in ${!config_@}; do
    echo "${var}=${!var}"
  done
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
  local program=$1

  [[ $(which "${program}" 2> /dev/null) ]]
}

is_travis_build() {
  [[ "${TRAVIS:-}" = "true" ]]
}

is_appveyor_build() {
  [[ "${APPVEYOR:-}" = "True" ]]
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

  image_format_number="$(hexdump -n 4 -e '2/4 "%04d " "\n"' "${image_path}")"
  [[ $((image_format_number>>(spur_bit-1) & 1)) -eq 1 ]]
}

is_headless() {
  [[ "${config_headless}" = "true" ]]
}

ston_includes_loading() {
  grep -Fq "#loading" "${config_ston}"
}

debug_enabled() {
  [[ "${config_debug}" = "true" ]]
}

check_build_status() {
  local build_status
  if is_file "${BUILD_STATUS_FILE}"; then
    build_status=$(cat "${BUILD_STATUS_FILE}")
    if is_nonzero "${build_status}"; then
      exit 1
    fi
  fi
}

check_final_build_status() {
  local build_status

  if ! is_file "${BUILD_STATUS_FILE}"; then
    print_error_and_exit "Build failed before tests were performed correctly."
  fi
  build_status=$(cat "${BUILD_STATUS_FILE}")
  report_build_metrics "${build_status}"
  if is_nonzero "${build_status}"; then
    exit 1
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
    curl -f -s -L --retry 3 -o "${target}" "${url}" || print_error_and_exit \
      "curl failed to download ${url} to '${target}'."
  elif program_exists "wget"; then
    wget -q -O "${target}" "${url}" || print_error_and_exit \
      "wget failed to download ${url} to '${target}'."
  else
    print_error_and_exit "Please install curl or wget."
  fi
}

resolve_path() {
  local path=$1

  if is_cygwin_build; then
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

git_log() {
  local format_value=$1
  local output
  output=$(git --no-pager log -1 --pretty=format:"${format_value}")
  echo "${output/\"/\\\"}" # Escape double quotes
}


export_coveralls_data() {
  local service_name="unknown"
  local branch_name="unknown"
  local url="unknown"
  local job_id="unknown"

  if is_travis_build; then
    service_name="travis-ci"
    branch_name="${TRAVIS_BRANCH}"
    url="https://github.com/${TRAVIS_REPO_SLUG}.git"
    job_id="${TRAVIS_JOB_ID}"
  elif is_appveyor_build; then
    service_name="appveyor"
    branch_name="${APPVEYOR_REPO_BRANCH}"
    url="https://github.com/${APPVEYOR_REPO_NAME}.git"
    job_id="${APPVEYOR_BUILD_ID}"
  elif is_gitlabci_build; then
    service_name="gitlab-ci"
    branch_name="${CI_COMMIT_REF_NAME}"
    url="${CI_PROJECT_URL}"
    job_id="${CI_PIPELINE_ID}.${CI_JOB_ID}"
  fi

  cat >"${SMALLTALK_CI_BUILD}/coveralls_data.json" <<EOL
{
  "git": {
    "branch": "${branch_name}",
    "head": {
      "author_email": "$(git_log "%ae")",
      "author_name": "$(git_log "%aN")",
      "committer_email": "$(git_log "%ce")",
      "committer_name": "$(git_log "%cN")",
      "id": "$(git_log "%H")",
      "message": "$(git_log "%s")"
    },
    "remotes": [
      {
        "url": "${url}",
        "name": "origin"
      }
    ]
  },
  "service_job_id": "${job_id}",
  "service_name": "${service_name}"
}
EOL
}

upload_coveralls_results() {
  local curl_status=0
  local coverage_results="${SMALLTALK_CI_BUILD}/coveralls_results.json"

  if is_file "${coverage_results}"; then
    print_info "Uploading coverage results to Coveralls..."
    curl -s -F json_file="@${coverage_results}" "${COVERALLS_API}" > /dev/null || curl_status=$?
    if is_nonzero "${curl_status}"; then
      print_error "Failed to upload coverage results (curl error code #${curl_status})"
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

  if [[ "${config_tracking}" != "true" ]]; then
    return 0
  fi

  if is_travis_build; then
    env_name="TravisCI"
  elif is_appveyor_build; then
    env_name="AppVeyor"
  else
    return 0 # Only report build metrics when running on TravisCI or AppVeyor
  fi

  project_slug="${TRAVIS_REPO_SLUG:-${APPVEYOR_REPO_NAME:-}}"
  api_url="${GITHUB_API}/repos/${project_slug}"
  status_code=$(curl -w %{http_code} -s -o /dev/null "${api_url}")
  if [[ "${status_code}" != "200" ]]; then
    return 0 # Not a public repository
  fi

  curl -s --header "X-BUILD-DURATION: ${duration}" \
          --header "X-BUILD-ENV: ${env_name}" \
          --header "X-BUILD-SMALLTALK: ${config_smalltalk}" \
          --header "X-BUILD-STATUS: ${build_status}" \
            "https://smalltalkci.fniephaus.com/api/" > /dev/null || true
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

  $cmd -u $format
}

travis_wait() {
  local timeout="${SMALLTALK_CI_TIMEOUT:-}"

  local cmd="$@"

  if ! is_int "${timeout}"; then
    $cmd
    return $?    
  fi

  $cmd &
  local cmd_pid=$!

  travis_jigger $! $timeout $cmd &
  local jigger_pid=$!
  local result

  {
    wait $cmd_pid 2>/dev/null
    result=$?
    ps -p$jigger_pid &>/dev/null && kill $jigger_pid
  }

  if [ $result -ne 0 ]; then
    print_error_and_exit "The command $cmd exited with $result."
  fi

  return $result
}

travis_jigger() {
  # helper method for travis_wait()
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

  echo -e "\n${ANSI_BOLD}${ANSI_RED}Timeout (${timeout} minutes) reached. Terminating \"$@\"${ANSI_RESET}\n"
  kill -9 $cmd_pid
}

fold_start() {
  local identifier=$1
  local title=$2
  local prefix="${SMALLTALK_CI_TRAVIS_FOLD_PREFIX:-}"

  timer_start_time=$(timer_nanoseconds)
  travis_timer_id=$(printf %08x $(( RANDOM * RANDOM )))
  if is_travis_build; then
    echo -en "travis_fold:start:${prefix}${identifier}\r${ANSI_CLEAR}"
    echo -en "travis_time:start:$travis_timer_id\r${ANSI_CLEAR}"
  fi
  echo -e "${ANSI_BOLD}${ANSI_BLUE}${title}${ANSI_RESET}"
}

fold_end() {
  local identifier=$1
  local prefix="${SMALLTALK_CI_TRAVIS_FOLD_PREFIX:-}"
  local timer_end_time=$(timer_nanoseconds)
  local duration=$(($timer_end_time-$timer_start_time))

  if is_travis_build; then
    echo -en "travis_time:end:$travis_timer_id:start=$timer_start_time,finish=$timer_end_time,duration=$duration\r${ANSI_CLEAR}"
    echo -en "travis_fold:end:${prefix}${identifier}\r${ANSI_CLEAR}"
  else
    duration=$(echo "${duration}" | awk '{printf "%.3f\n", $1/1000000000}')
    printf "${ANSI_RESET}${ANSI_BLUE} > Time to run: %ss ${ANSI_RESET}\n" "${duration}"
  fi
}
