#!/usr/bin/env bash

set -eux

EPICS_VERSION_DOTTED=$(echo $EPICS_BASE_VERSION | sed -E s/-/\./g)

mkdir epics-R${EPICS_BASE_VERSION}
cd epics-R${EPICS_BASE_VERSION}
wget https://epics-controls.org/download/base/base-${EPICS_VERSION_DOTTED}.tar.gz
tar -xvzf base-${EPICS_VERSION_DOTTED}.tar.gz
rm -f base-${EPICS_VERSION_DOTTED}.tar.gz

mv base-${EPICS_VERSION_DOTTED} base
make -j ${JOBS} -C base install clean
