#!../../bin/linux-x86_64/BaslerCamera

< envPaths

# Register all support components
dbLoadDatabase("${TOP}/dbd/BaslerCamera.dbd")
BaslerCamera_registerRecordDeviceDriver(pdbbase) 

# IOC and device specific configuration
epicsEnvSet("P", "${EPICS_PV_AREA_PREFIX}")
epicsEnvSet("R", "${EPICS_PV_DEVICE_PREFIX}")
epicsEnvSet("PREFIX", "$(P)$(R)")
epicsEnvSet("MAX_IMAGE_WIDTH", 1280)
epicsEnvSet("MAX_IMAGE_HEIGHT", 1024)
epicsEnvSet("MAX_IMAGE_PIXELS", 1310720)
epicsEnvSet("IP_ADDRESS", "${BASLER_IP_ADDRESS}")

epicsEnvSet("PORT", "CAM")
epicsEnvSet("EPICS_CA_AUTO_ARRAY_BYTES", "YES")

# Include ADCore to path for loading its databases relatively
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db:$(ADGENICAM)/db")

# Configure camera driver
aravisConfig("$(PORT)", "$(IP_ADDRESS)", 0, 0, 0)
dbLoadRecords("$(ADARAVIS)/db/aravisCamera.template", "P=$(PREFIX), R=cam1:, PORT=$(PORT)")
dbLoadRecords("$(TOP)/db/acA1300-75gm.db", "P=$(PREFIX), R=cam1:, PORT=$(PORT)")

# Trace error and warning messages
asynSetTraceMask("$(PORT)", 0, ERROR | WARNING)

# Load Sirius standard naming compliant records
# As they depend on the previous records, this must be done last
# epicsEnvSet("MARK_WIDTH", 3)
# dbLoadRecords("${TOP}/db/standard.db", "P=$(P), R=$(R), MARK_WIDTH=$(MARK_WIDTH)")

# Configure areaDetector plugins
epicsEnvSet("QSIZE", 20)
epicsEnvSet("QSIZE_HDF5", 50)

< plugins.cmd

iocInit()
