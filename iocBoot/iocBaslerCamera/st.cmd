#!../../bin/linux-x86_64/BaslerCamera

#- You may have to change BaslerCamera to something else
#- everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase("${TOP}/dbd/BaslerCamera.dbd")
BaslerCamera_registerRecordDeviceDriver(pdbbase) 

## Set up device identification
epicsEnvSet("P", "${EPICS_PV_AREA_PREFIX}")
epicsEnvSet("R", "${EPICS_PV_DEVICE_PREFIX}")
epicsEnvSet("IP_ADDRESS", "${BASLER_IP_ADDRESS}")
epicsEnvSet("PREFIX", "$(P)$(R)")
epicsEnvSet("PORT", "CAMPORT")

## Setup overlay markers line width
epicsEnvSet("MARK_WIDTH", 3)

## Configure connection to camera
aravisConfig("$(PORT)", "$(IP_ADDRESS)", 0, 0, 0)

## Load record instances
dbLoadRecords("${TOP}/db/acA1300-75gm.db", "P=$(PREFIX), R=Cam1, PORT=$(PORT)")
dbLoadRecords("${TOP}/db/standard.db", "P=$(P), R=$(R), MARK_WIDTH=$(MARK_WIDTH), PORT=$(PORT)")

iocInit()
