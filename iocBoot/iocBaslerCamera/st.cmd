#!../../bin/linux-x86_64/BaslerCamera

< envPaths

# Register all support components
dbLoadDatabase("${TOP}/dbd/BaslerCamera.dbd")
BaslerCamera_registerRecordDeviceDriver(pdbbase) 

# Set up environment variables
epicsEnvSet("P", "${EPICS_PV_AREA_PREFIX}")
epicsEnvSet("R", "${EPICS_PV_DEVICE_PREFIX}")
epicsEnvSet("IP_ADDRESS", "${BASLER_IP_ADDRESS}")

# Configure connection to camera
aravisConfig("BaslerCamera", "$(IP_ADDRESS)", 0, 0, 0)

# Load record instances
dbLoadRecords("${TOP}/db/acA1300-75gm.db", "P=$(P), R=$(R), PORT=BaslerCamera")

iocInit()
