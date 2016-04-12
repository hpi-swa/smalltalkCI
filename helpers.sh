################################################################################
# This file provides helper functions for smalltalkCI. It is used in the context
# of a smalltalkCI build and it is not meant to be executed by itself.
################################################################################

ANSI_RED="\033[31;1m"
ANSI_GREEN="\033[32;1m"
ANSI_YELLOW="\033[33;1m"
ANSI_BLUE="\033[34;1m"
ANSI_RESET="\033[0m"
ANSI_CLEAR="\033[0K"

print_info() {
  printf "${ANSI_BLUE}%s${ANSI_RESET}\n" "$1"
}

print_notice() {
  printf "${ANSI_YELLOW}%s${ANSI_RESET}\n" "$1"
}

print_success() {
  printf "${ANSI_GREEN}%s${ANSI_RESET}\n" "$1"
}

print_error() {
  printf "${ANSI_RED}%s${ANSI_RESET}\n" "$1" 1>&2
}

print_error_and_exit() {
  print_error "$1"
  exit 1
}

print_help() {
  cat <<EOF
  USAGE: $(basename -- $0) [options] /path/to/project/your_smalltalk.ston

  This program prepares Smalltalk images/vms, loads projects and runs tests.

  OPTIONS:
    --clean             Clear cache and delete builds.
    -d | --debug        Enable debug mode.
    -h | --help         Show this help text.
    --headfull          Open vm in headfull mode and do not close image.
    --install           Install symlink to this smalltalkCI instance.
    -s | --smalltalk    Overwrite Smalltalk image selection.
    --uninstall         Remove symlink to any smalltalkCI instance.
    -v | --verbose      Enable 'set -x'.

  GEMSTONE OPTIONS:
    --gs-BRANCH=<branch-SHA-tag>
                        Name of GsDevKit_home branch, SHA or tag. Default is 'master'.

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

print_results() {
  local build_dir=$1
  local status=0
  local junit_xml_file
  junit_xml_file=${build_dir}/*.xml

  if is_travis_build && [[ $(ls ${junit_xml_file} 2> /dev/null) ]]; then
    travis_fold start junit_xml "JUnit XML Output"
      cat ${junit_xml_file}
      printf "\n"
    travis_fold end junit_xml
  fi

  python "${SMALLTALK_CI_HOME}/lib/junit_xml_prettfier.py" \
      "${build_dir}" || status=$?

  if is_travis_build && ! [[ ${status} -eq 0 ]]; then
    print_steps_to_reproduce_locally $status
  fi

  return "${status}"
}

print_steps_to_reproduce_locally() {
  local status=$1

  printf "\n"
  echo "     To reproduce the failed build locally, download smalltalkCI"
  echo "     and try to run something like:"
  printf "\n"
  print_notice "      /path/to/run.sh --headfull /path/to/project/.smalltalk.ston"
  printf "\n"
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

program_exists() {
  local program=$1

  [[ $(which "${program}" 2> /dev/null) ]]
}

is_travis_build() {
  [[ "${TRAVIS:-}" = "true" ]]
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

debug_enabled() {
  [[ "${config_debug}" = "true" ]]
}

download_file() {
  local url=$1

  if is_empty "${url}"; then
    print_error "download_file() expects an URL."
    exit 1
  fi

  if program_exists "curl"; then
    curl -s "${url}"
  elif program_exists "wget"; then
    wget -q -O - "${url}"
  else
    print_error "Please install curl or wget."
    exit 1
  fi
}

return_vars() {
  (IFS='|'; echo "$*")
}

set_vars() {
  local variables=(${@:1:(($# - 1))})
  local values="${!#}"

  IFS='|' read -r "${variables[@]}" <<< "${values}"
}


################################################################################
# Travis-related helper functions (based on https://git.io/vzcTj).
################################################################################

timer_start() {
  timer_start_time=$(timer_nanoseconds)
  if is_travis_build; then
    travis_timer_id=$(printf %08x $(( RANDOM * RANDOM )))
    echo -en "travis_time:start:$travis_timer_id\r${ANSI_CLEAR}"
  fi
}

timer_finish() {
  timer_end_time=$(timer_nanoseconds)
  local duration=$(($timer_end_time-$timer_start_time))
  if is_travis_build; then
    echo -en "travis_time:end:$travis_timer_id:start=$timer_start_time,finish=$timer_end_time,duration=$duration\r${ANSI_CLEAR}"
  else
    duration=$(echo "scale=3;${duration}/1000000000" | bc)
    printf "\e[0;34m > Time to run: %ss ${ANSI_RESET}\n" "${duration}"
  fi
}

function timer_nanoseconds() {
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

travis_fold() {
  local action=$1
  local name=$2
  local title="${3:-}"
  local prefix="${SMALLTALK_CI_TRAVIS_FOLD_PREFIX:-}"

  if is_travis_build; then
    echo -en "travis_fold:${action}:${prefix}${name}\r${ANSI_CLEAR}"
  fi
  if is_not_empty "${title}"; then
    echo -e "${ANSI_BLUE}${title}${ANSI_RESET}"
  fi
}
