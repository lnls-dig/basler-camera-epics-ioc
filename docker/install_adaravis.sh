#!/usr/bin/env bash

set -eux

apt update
apt install -y --no-install-recommends \
        libaravis-0.8-0 \
        libaravis-dev \
        libusb-1.0-0-dev

AREA_DETECTOR=/opt/areaDetector-R${AREA_DETECTOR_VERSION}

git clone --depth 1 --branch R${AREA_DETECTOR_VERSION} \
    https://github.com/areaDetector/areaDetector \
    $AREA_DETECTOR

cd $AREA_DETECTOR
git submodule update --init --depth 1 -j ${JOBS} \
    ADCore \
    ADSupport \
    ADGenICam \
    ADAravis

rm -rf .git

# Setup configuration files
cd configure
cat EXAMPLE_RELEASE.local | \
    sed -e "s|^#ADCORE=|ADCORE=|" \
        -e "s|^#ADSUPPORT=|ADSUPPORT=|" \
        -e "s|^#ADGENICAM=|ADGENICAM=|" \
        -e "s|^#ADARAVIS=|ADARAVIS=|" \
    > RELEASE.local

cat EXAMPLE_RELEASE_LIBS.local | \
    sed -e "s|^SUPPORT=.*$|SUPPORT=/opt|" \
        -e "s|^ASYN=.*$|ASYN=/opt/asyn-R${ASYN_VERSION}|" \
        -e "s|^AREA_DETECTOR=.*$|AREA_DETECTOR=/opt/areaDetector-R${AREA_DETECTOR_VERSION}|" \
        -e "s|^EPICS_BASE=.*$|EPICS_BASE=/opt/epics-R${EPICS_BASE_VERSION}/base|" \
    > RELEASE_LIBS.local

cat EXAMPLE_RELEASE_PRODS.local | \
    sed -e "s|^SUPPORT=.*$|SUPPORT=/opt|" \
        -e "s|^ASYN=.*$|ASYN=/opt/asyn-R${ASYN_VERSION}|" \
        -e "s|^AREA_DETECTOR=.*$|AREA_DETECTOR=/opt/areaDetector-R${AREA_DETECTOR_VERSION}|" \
        -e "s|^AUTOSAVE=.*$|AUTOSAVE=/opt/autosave-R${AUTOSAVE_VERSION}|" \
        -e "s|^BUSY=.*$|BUSY=/opt/busy-R${BUSY_VERSION}|" \
        -e "s|^CALC=.*$|CALC=/opt/calc-R${CALC_VERSION}|" \
        -e "s|^SSCAN=.*$|SSCAN=/opt/sscan-R${SSCAN_VERSION}|" \
        -e "s|^DEVIOCSTATS=|#DEVIOCSTATS=|" \
        -e "s|^SNCSEQ=|#SNCSEQ=|" \
        -e "s|^EPICS_BASE=.*$|EPICS_BASE=/opt/epics-R${EPICS_BASE_VERSION}/base|" \
    > RELEASE_PRODS.local

GLIB_INCLUDE=`pkg-config --cflags-only-I glib-2.0 | sed -e "s|-I||g"`
cat EXAMPLE_CONFIG_SITE.local | \
    sed -e "s|^BOOST_EXTERNAL\s*=|BOOST_EXTERNAL=NO|" \
        -e "s|^WITH_PVA\s*=|WITH_PVA=NO|" \
        -e "s|^WITH_QSRV\s*=|WITH_QSRV=NO|" \
        -e "s|^WITH_BLOSC\s*=|WITH_BLOSC=NO|" \
        -e "s|^WITH_BITSHUFFLE=\s*=|WITH_BITSHUFFLE=NO|" \
        -e "s|^WITH_GRAPHICSMAGICK\s*=|WITH_GRAPHICSMAGICK=NO|" \
        -e "s|^WITH_HDF5\s*=|WITH_HDF5=NO|" \
        -e "s|^WITH_JSON=\s*=|WITH_JSON=NO|" \
        -e "s|^WITH_JPEG=\s*=|WITH_JPEG=NO|" \
        -e "s|^WITH_NETCDF\s*=|WITH_NETCDF=NO|" \
        -e "s|^WITH_NEXUS\s*=|WITH_NEXUS=NO|" \
        -e "s|^WITH_OPENCV\s*=|WITH_OPENCV=NO|" \
        -e "s|^WITH_SZIP\s*=|WITH_SZIP=NO|" \
        -e "s|^WITH_TIFF\s*=|WITH_TIFF=NO|" \
        -e "s|^WITH_ZLIB=\s*=|WITH_ZLIB=NO|" \
        -e "s|^GLIB_INCLUDE\s*=.*$|GLIB_INCLUDE=$GLIB_INCLUDE|" \
        -e "s|^ARAVIS_INCLUDE\s*=.*$|ARAVIS_INCLUDE=/usr/include/aravis-0.8|" \
    > CONFIG_SITE.local
cd -

make -j ${JOBS}
