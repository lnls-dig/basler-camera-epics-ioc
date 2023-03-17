#!/bin/bash -ex

cd /opt

# Install module from GitHub tagged versions
install_module() {
    github_org=$1
    module_name=$2
    version=$3
    release_content="$4"

    # Download repository
    wget https://github.com/$github_org/$module_name/archive/refs/tags/R$version.tar.gz
    tar -xvzf R$version.tar.gz
    rm -f R$version.tar.gz

    cd $module_name-R$version
    echo -e "$release_content" > configure/RELEASE

    make -j ${JOBS} install
    make -j ${JOBS} clean

    cd -
}

install_module 'epics-modules' 'asyn' $ASYN_VERSION "
EPICS_BASE = /opt/epics-R${EPICS_BASE_VERSION}/base
"

install_module 'epics-modules' 'sscan' $SSCAN_VERSION "
EPICS_BASE = /opt/epics-R${EPICS_BASE_VERSION}/base
"

install_module 'epics-modules' 'autosave' $AUTOSAVE_VERSION "
EPICS_BASE = /opt/epics-R${EPICS_BASE_VERSION}/base
"

install_module 'epics-modules' 'calc' $CALC_VERSION "
SSCAN = /opt/sscan-R${SSCAN_VERSION}

EPICS_BASE = /opt/epics-R${EPICS_BASE_VERSION}/base
"

install_module 'epics-modules' 'busy' $BUSY_VERSION "
ASYN = /opt/asyn-R${ASYN_VERSION}
AUTOSAVE = /opt/autosave-R${AUTOSAVE_VERSION}
BUSY = /opt/busy-R${BUSY_VERSION}

EPICS_BASE = /opt/epics-R${EPICS_BASE_VERSION}/base
"
