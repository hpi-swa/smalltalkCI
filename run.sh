#!/bin/bash

set -e

# Include helper functions
source helpers.sh

# ==============================================================================
# Check required software
# ==============================================================================
case "$(uname -s)" in
    "Linux"|"Darwin")
        ;;
    *)
        print_error "Unsupported platform '$(uname -s)'"
        exit 1
        ;;
esac
# ==============================================================================

# ==============================================================================
# Set all required variables
# 
# smalltalkCI options are loaded in the following order:
# default, environment variables, project's .travis.yml, user arguments/flags
#
# smalltalkCI path variables are loaded in the following order:
# default, environment variables
# ==============================================================================
if [[ "${TRAVIS}" != "true" ]] && [[ $# -eq 0 ]]; then
  print_help
  exit 0
fi

# Specify options for `getopts`
options="hd:b:g:our:s:x:y:z"

project_home=""
if [[ -n "${PROJECT_HOME}" ]]; then
  project_home=$PROJECT_HOME
else
  project_home=${!#} # Last parameter
fi

if [[ ! -d "${project_home}" ]]; then
  print_error "Project home is not found."
  exit 1
fi

if [[ ${project_home:0:1} != "/" ]]; then
    project_home=$(cd "${project_home}" && pwd)
fi

# Set smalltalkCI options to default
baseline=""
baseline_group=""
packages="packages"
force_update=""
builder_ci_fallback="false"
run_script=""
excluded_categories=""
excluded_classes=""
keep_open="false"

# Check environment variables for backwards-compatibility
[[ -n "${BASELINE_GROUP}" ]] && baseline_group="${BASELINE_GROUP}"
[[ -n "${PACKAGES}" ]] && packages="${PACKAGES}"
[[ -n "${FORCE_UPDATE}" ]] && force_update="${FORCE_UPDATE}"
[[ -n "${BUILDERCI}" ]] && builder_ci_fallback="${BUILDERCI}"
[[ -n "${RUN_SCRIPT}" ]] && run_script="${RUN_SCRIPT}"
[[ -n "${EXCLUDE_CATEGORIES}" ]] && excluded_categories="${EXCLUDE_CATEGORIES}"
[[ -n "${EXCLUDE_CLASSES}" ]] && excluded_classes="${EXCLUDE_CLASSES}"
[[ -n "${KEEP_OPEN}" ]] && keep_open="${KEEP_OPEN}"

# Load config from project"s `.travis.yml`
user_travis_conf="${project_home}/.travis.yml"
if [[ -f "$user_travis_conf" ]]; then
    eval $(ruby yaml_parser.rb $user_travis_conf)
else
    print_notice "Could not find '${user_travis_conf}'."
fi

# Handle all other arguments and flags
while :
do
  case "$1" in
  --baseline)
    baseline="$2"
    shift 2 ;;
  --baseline-group)
    baseline_group="$2"
    shift 2 ;;
  --builder-ci)
    builder_ci_fallback="true"
    shift ;;
  --directory)
    directory="$2"
    shift 2 ;;
  --excluded-categories)
    excluded_categories="$2"
    shift 2 ;;
  --excluded-classes)
    excluded_classes="$2"
    shift 2 ;;
  --force-update)
    force_update="true"
    shift ;;
  -h | --help)
    print_help
    exit 0 ;;
  -o | --keep-open)
    keep_open="true"
    shift ;;
  --script)
    run_script="$2"
    shift 2 ;;
  -s | --smalltalk)
    export SMALLTALK="$2"
    shift 2 ;;
  --)
    shift
    break ;;
  -*)
    print_error "Unknown option: $1"
    exit 1 ;;
  *) 
    break ;;
  esac
done

if [[ -z "${baseline}" ]]; then
  print_error "Baseline could not be found."
  exit 1
fi
if [[ ${packages:0:1} == "/" ]]; then
  packages=${packages:1}
  print_notice "Please remove the leading slash from 'smalltalk_packages'."
fi

# Make sure smalltalkCI path variables are set
if [[ -z "${SMALLTALK_CI_HOME}" ]] && [[ "${TRAVIS}" != "true" ]]; then
  export SMALLTALK_CI_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  source "${SMALLTALK_CI_HOME}/env_vars"
fi

# Make sure $SMALLTALK is set
if [[ -z "${SMALLTALK}" ]]; then
  print_error "\$SMALLTALK is not defined."
  exit 1
fi
# ==============================================================================

# ==============================================================================
# Fall back to builderCI if requested or for GemStone builds
# ==============================================================================
if [[ "${builder_ci_fallback}" == "true" ]] || [[ "${SMALLTALK}" == "GemStone"* ]]; then
    # Make sure the script runs on Linux
    if [[ "$(uname -s)" != "Linux" ]]; then
        print_error "builderCI only supports Linux builds."
        exit 1
    fi
    if [[ "${TRAVIS}" ]]; then
        # Make sure the script runs on standard infrastructure
        sudo -n true
        if [[ "$?" != 0 ]]; then
            print_error "sudo is not available."
            exit 1
        fi
    fi

    print_info "Starting legacy build using builderCI..."
    export ST="${SMALLTALK}"
    export PROJECT_HOME="${project_home}"
    cd $HOME
    wget -q -O builderCI.zip https://github.com/dalehenrich/builderCI/archive/master.zip
    unzip -q builderCI.zip
    cd builderCI-*
    source build_env_vars
    ln -s $PROJECT_HOME $GIT_PATH
    print_info "builderCI: Build image..."
    ./build_image.sh
    print_info "builderCI: Run tests..."
    exit_status=0
    $BUILDER_CI_HOME/testTravisCI.sh -verbose || exit_status=$?
    exit $exit_status
fi
# ==============================================================================

# ==============================================================================
# Prepare folders
# ==============================================================================
print_info "Preparing folders..."
[[ -d "${SMALLTALK_CI_CACHE}" ]] || mkdir "${SMALLTALK_CI_CACHE}"
[[ -d "${SMALLTALK_CI_BUILD_BASE}" ]] || mkdir "${SMALLTALK_CI_BUILD_BASE}"
[[ -d "${SMALLTALK_CI_VMS}" ]] || mkdir "${SMALLTALK_CI_VMS}"
# Create folder for this build (should not exist)
mkdir "${SMALLTALK_CI_BUILD}"
# Link project folder to git_cache
ln -s "${project_home}" "${SMALLTALK_CI_GIT}"
# ==============================================================================

# ==============================================================================
# Start build accordingly
# ==============================================================================
exit_status=0
case "${SMALLTALK}" in
    Squeak*)
        print_info "Starting Squeak build..."
        source "${SMALLTALK_CI_HOME}/squeak/run.sh"
        ;;
    Pharo*)
        print_info "Starting Pharo build..."
        source "${SMALLTALK_CI_HOME}/pharo/run.sh"
        ;;
    *)
        print_error "Unknown Smalltalk version '${SMALLTALK}'."
        exit 1
        ;;
esac
# ==============================================================================

# ==============================================================================
# Check exit status
# ==============================================================================
printf "\n\n"
if [[ $exit_status -eq 0 ]]; then
    print_success "Build successful :)"
else
    print_error "Build failed :("
    if [[ "${TRAVIS}" = "true" ]]; then
        print_info "\n\nTo reproduce the failed build locally, download smalltalkCI and try running something like:"
        print_notice "\n./run.sh --keep-open /path/to/your/project"
    fi
fi
printf "\n"
# ==============================================================================

exit $exit_status
