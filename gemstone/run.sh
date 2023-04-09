################################################################################
# This file provides GemStone support for smalltalkCI. It is used in the context
# of a smalltalkCI build and it is not meant to be executed by itself.
################################################################################

# set -x
local STONE_NAME="smalltalkci"
local SUPERDOIT_BRANCH=v3.1
local SUPERDOIT_DOWNLOAD=git@github.com:dalehenrich/superDoit.git
local SUPERDOIT_DOWNLOAD=https://github.com/dalehenrich/superDoit.git
local GSDEVKIT_STONES_BRANCH=v1.1
local GSDEVKIT_STONES_DOWNLOAD=git@github.com:GsDevKit/GsDevKit_stones.git
local GSDEVKIT_STONES_DOWNLOAD=https://github.com/GsDevKit/GsDevKit_stones.git
local STONES_REGISTRY_NAME=smalltalkCI_run
local STONE_STARTED=""
local STONE_DIRECTORY=""
local STONES_STONES_HOME=$SMALLTALK_CI_BUILD/stones
local STONES_PROJECTS_HOME=$SMALLTALK_CI_BUILD/repos
local STONES_PRODUCTS=$SMALLTALK_CI_BUILD/products
local STONES_PROJECT_SET_NAME=devkit
local GEMSTONE_DEBUG=""

vers=`echo "${config_smalltalk}" | sed 's/GemStone64-//'`

local PLATFORM="`uname -sm | tr ' ' '-'`"
case "$PLATFORM" in
    Darwin-arm64)
			local GEMSTONE_PRODUCT_NAME="GemStone64Bit${vers}-arm64.Darwin"
			;;
    Darwin-x86_64)
			local GEMSTONE_PRODUCT_NAME="GemStone64Bit${vers}-i386.Darwin"
			;;
		Linux-x86_64)
		local GEMSTONE_PRODUCT_NAME="GemStone64Bit${vers}-x86_64.Linux"
      ;;
		*)
			echo "This script should only be run on Mac (Darwin-i386 or Darwin-arm64), or Linux (Linux-x86_64) ). The result from \"uname -sm\" is \"`uname -sm`\""
			exit 1
      ;;
esac

echo "GEMSTONE_PRODUCT_NAME=$GEMSTONE_PRODUCT_NAME"

################################################################################
# Clone the superDoit project, install GemStone
################################################################################
gemstone::prepare_superDoit() {
	pushd $STONES_PROJECTS_HOME
		if [ -d "$STONES_PROJECTS_HOME/superDoit" ] ; then
			echo "Reusing existing superDoit project directory: $STONES_PROJECTS_HOME/superDoit"
		else
			fold_start clone_superDoit "Cloning superDoit..."
				git clone -b "${SUPERDOIT_BRANCH}" --depth 1 "${SUPERDOIT_DOWNLOAD}"
 				export PATH="`pwd`/superDoit/bin:`pwd`/superDoit/examples/utility:$PATH"
				fold_start install_superDoit_gemstone "Downloading GemStone for superDoit..."
					install.sh $GS_ALTERNATE_PRODUCTS
				fold_end install_superDoit_gemstone
			fold_end clone_superDoit
		fi
		export PATH="`pwd`/superDoit/bin:`pwd`/superDoit/examples/utility:$PATH"
		fold_start versionreport_superDoit "superDoit versionReport.solo..."
			versionReport.solo
		fold_end versionreport_superDoit
	popd
}

################################################################################
# Prepare environment for running GemStone
################################################################################
gemstone::prepare_gemstone() {
echo "[Info] Creating /opt/gemstone directory"
  if [ ! -e /opt/gemstone ]
    then
    sudo mkdir -p /opt/gemstone /opt/gemstone/log /opt/gemstone/locks
    sudo chown $USER:${GROUPS[0]} /opt/gemstone /opt/gemstone/log /opt/gemstone/locks
    sudo chmod 770 /opt/gemstone /opt/gemstone/log /opt/gemstone/locks
  else
    echo "[Warning] /opt/gemstone directory already exists"
    echo "to replace it, remove or rename it and rerun this script"
  fi
}
################################################################################
# Clone the GsDevKit_stones project
################################################################################
gemstone::prepare_gsdevkit_stones() {
	fold_start clone_gsdevkit_stones "Cloning GsDevKit_stones..."
		pushd "$STONES_PROJECTS_HOME"
			if [ ! -d "$STONES_PROJECTS_HOME/GsDevKit_stones" ] ; then
				git clone -b "${GSDEVKIT_STONES_BRANCH}" --depth 1 "${GSDEVKIT_STONES_DOWNLOAD}"
			fi
			export PATH="`pwd`/GsDevKit_stones/bin:$PATH"
		popd
		export STONES_DATA_HOME="$SMALLTALK_CI_BUILD/.stones_data_home"
		if [ ! -d "$STONES_DATA_HOME" ] ; then
			createRegistry.solo $STONES_REGISTRY_NAME $GEMSTONE_DEBUG
			createProjectSet.solo --registry=$STONES_REGISTRY_NAME --projectSet=$STONES_PROJECT_SET_NAME \
				                 --from=$STONES_PROJECTS_HOME/GsDevKit_stones/bin/gsdevkitProjectSpecs.ston \
												 --key=server --https $GEMSTONE_DEBUG
			cloneProjectsFromProjectSet.solo  --registry=$STONES_REGISTRY_NAME --projectSet=$STONES_PROJECT_SET_NAME \
				                 --projectDirectory=$STONES_PROJECTS_HOME $GEMSTONE_DEBUG
		fi
		registryReport.solo
	fold_end clone_gsdevkit_stones
}

################################################################################
# Create a GemStone stone.
################################################################################
gemstone::prepare_stone() {
  local gemstone_version

  gemstone_version="$(echo $1 | cut -f2 -d-)"

  fold_start create_stone "Creating stone..."
		registerProductDirectory.solo --registry=$STONES_REGISTRY_NAME --productDirectory=$STONES_PRODUCTS $GEMSTONE_DEBUG
		if [ "$GS_ALTERNATE_PRODUCTS"x != "x" ] ; then
			# matches superDoit gemstone version, so reuse the download
			registerProduct.solo --registry=$STONES_REGISTRY_NAME --fromDirectory=$GS_ALTERNATE_PRODUCTS ${gemstone_version} $GEMSTONE_DEBUG
		else
			downloadGemStone.solo --directory=$STONES_PRODUCTS --registry=$STONES_REGISTRY_NAME ${gemstone_version} $GEMSTONE_DEBUG
		fi
		if [ "$STONE_DIRECTORY"x = "x" ] ; then
			createStone.solo --force --registry=$STONES_REGISTRY_NAME --template=minimal_seaside \
				--start --root=$STONES_STONES_HOME/$STONE_NAME "${gemstone_version}" $GEMSTONE_DEBUG
			STONE_DIRECTORY=$STONES_STONES_HOME/$STONE_NAME
			STONE_STARTED="TRUE"
		else
			STONE_STARTED="FALSE"
			if [ ! -d "$STONE_DIRECTORY" ] ; then
				print_error_and_exit "The directory named by --gs-STONE_DIR option ($STONE_DIRECTORY) is expected to exist"
			fi
		fi
		pushd $STONE_DIRECTORY
			if [ "${GEMSTONE+set}" ] ; then
				echo "GEMSTONE = $GEMSTONE (PREDEFINED)"
			else
				export GEMSTONE="`pwd`/product"
				echo "GEMSTONE = $GEMSTONE (DEFAULT VALUE)"
			fi
			export PATH=$GEMSTONE/bin:$PATH
			loadTode.stone --projectDirectory=$STONES_PROJECTS_HOME $GEMSTONE_DEBUG
		popd
  fold_end create_stone
}

################################################################################
# Load project into GemStone stone.
# Locals:
#   config_project_home
#   config_ston
# Globals:
#   SMALLTALK_CI_HOME
################################################################################
gemstone::load_project() {
  local status=0

  fold_start load_server_project "Loading server project..."
 	pushd $STONE_DIRECTORY
		if [ "$GEMSTONE"x = "x" ] ; then
			export GEMSTONE="`pwd`/product"
		fi
		export PATH=$GEMSTONE/bin:$PATH
		loadSmalltalkCIProject.stone --projectRoot=$SMALLTALK_CI_HOME --config_ston=${config_ston} $GEMSTONE_DEBUG
		status=$?
	popd
 fold_end load_server_project

  if is_nonzero "${status}"; then
    print_error_and_exit "Failed to load project."
  fi
  check_and_consume_build_status_file
}


################################################################################
# Run tests.
# Locals:
#   config_project_home
#   config_ston
# Globals:
#   SMALLTALK_CI_HOME
################################################################################
gemstone::test_project() {
  local status=0

  fold_start run_tests "Running project tests..."
 	pushd $STONE_DIRECTORY
		if [ "$GEMSTONE"x = "x" ] ; then
			export GEMSTONE="`pwd`/product"
		fi
		export PATH=$GEMSTONE/bin:$PATH
		testSmalltalkCIProject.stone  --buildDirectory=$SMALLTALK_CI_BUILD --config_ston=${config_ston} --named='${config_smalltalk} Server (${STONE_NAME})' $GEMSTONE_DEBUG
		status=$?
	popd

	if [ "$STONE_STARTED" = "TRUE" ] ; then
    fold_start stop_stone "Stopping stone..."
      stopstone "${STONE_NAME}" DataCurator swordfish 
    fold_end stop_stone
	fi

	fold_end run_tests 
  if is_nonzero "${status}"; then
    print_error_and_exit "Error while testing server project."
  fi
  check_and_consume_build_status_file

	echo "[success]" > "${BUILD_STATUS_FILE}"
}

################################################################################
# Handle GemStone-specific shared memory needs for Darwin on GitHub.
################################################################################
gemstone::darwin_shared_mem_setup() {

	if is_github_build && is_sudo_enabled; then
		# Update shared memory, for github/Darwin builds, since default Darwin shared memory is too small t run GemStone
		case "$PLATFORM" in
	    Darwin-arm64 | Darwin-x86_64)
				echo "============"
			  totalMem="`sudo sysctl hw.memsize | cut -f2 -d' '`"
			  totalMemMB=$(($totalMem / 1048576))
			  shmmax="`sudo sysctl kern.sysv.shmmax | cut -f2 -d' '`"
			  shmall="`sysctl kern.sysv.shmall | cut -f2 -d' '`"
				
			  shmmaxMB=$(($shmmax / 1048576))
			  shmallMB=$(($shmall / 256))
			
			  # Print current values
			  echo "  Total memory available is $totalMemMB MB"
			  echo "  Max shared memory segment size is $shmmaxMB MB"
			  echo "  Max shared memory allowed is $shmallMB MB"
			
			  # Figure out the max shared memory segment size (shmmax) we want
			  # Use 75% of available memory but not more than 2GB
			  shmmaxNew=$(($totalMem * 3/4))
			  [[ $shmmaxNew -gt 2147483648 ]] && shmmaxNew=2147483648
			  shmmaxNewMB=$(($shmmaxNew / 1048576))
			  # Figure out the max shared memory allowed (shmall) we want
			  # The MacOSX default is 4MB, way too small
			  shmallNew=$(($shmmaxNew / 4096))
			  [[ $shmallNew -lt $shmall ]] && shmallNew=$shmall
			  shmallNewMB=$(($shmallNew / 256))
				echo "shmmaxNew=$shmmaxNew"
				if [[ $shmmaxNew -gt $shmmax ]]; then
					echo "[Info] Increasing max shared memory segment size to $shmmaxNewMB MB"
   				sudo sysctl -w kern.sysv.shmmax=$shmmaxNew
				fi
				echo "shmallNew=$shmallNew"
				if [ $shmallNew -gt $shmall ]; then
					echo "[Info] Increasing max shared memory allowed to $shmallNewMB MB"
					sudo sysctl -w kern.sysv.shmall=$shmallNew
				fi
				echo "============"
				;;
			*)
	      ;;
		esac
	fi
}

################################################################################
# Main entry point for GemStone builds.
################################################################################
run_build() {
  gemstone::parse_options "$@"

  case "$(uname -s)" in
    "Linux"|"Darwin")
      ;;
    *)
      print_error_and_exit "GemStone is not supported on '$(uname -s)'"
      ;;
  esac

	if [ ! -d "$STONES_PRODUCTS" ] ; then
		mkdir $STONES_PRODUCTS
	fi
	if [ ! -d "$STONES_PROJECTS_HOME" ] ; then
		mkdir $STONES_PROJECTS_HOME
	fi
	if [ "$STONE_DIRECTORY"x = "x" ] ; then
		if [ ! -d "$STONES_STONES_HOME" ] ; then
			mkdir $STONES_STONES_HOME
		fi
	fi

	gemstone::darwin_shared_mem_setup
	gemstone::prepare_gemstone
	gemstone::prepare_superDoit
	gemstone::prepare_gsdevkit_stones
  gemstone::prepare_stone "${config_smalltalk}"
  gemstone::load_project
  gemstone::test_project
}
################################################################################
# Handle GemStone-specific options.
################################################################################
gemstone::parse_options() {

  case "$(uname -s)" in
    "Linux"|"Darwin")
      ;;
    *)
      print_error_and_exit "GemStone is not supported on '$(uname -s)'"
      ;;
  esac

	GS_ALTERNATE_PRODUCTS=""

  while :
  do
    case "${1:-}" in
      --gs-DEBUG)
        GEMSTONE_DEBUG=" --debug"
				shift
        ;;
      --gs-PRODUCTS=*)
        GS_ALTERNATE_PRODUCTS="${1#*=}"
				shift
        ;;
      --gs-REPOS=*)
        STONES_PROJECTS_HOME="${1#*=}"
				shift
        ;;
      --gs-STONE_DIR=*)
        STONE_DIRECTORY="${1#*=}"
				shift
        ;;
      --gs-*)
        print_error_and_exit "Unknown GemStone-specific option: $1"
        ;;
      "")
        break
        ;;
      *)
        shift
        ;;
    esac
  done

	export GS_ALTERNATE_PRODUCTS
}

