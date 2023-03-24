#!../../bin/linux-x86_64/BaslerCamera

< envPaths

# Register all support components
dbLoadDatabase("${TOP}/dbd/BaslerCamera.dbd")
BaslerCamera_registerRecordDeviceDriver(pdbbase) 

# Set up environment variables
epicsEnvSet("P", "${EPICS_PV_AREA_PREFIX}")
epicsEnvSet("R", "${EPICS_PV_DEVICE_PREFIX}")
epicsEnvSet("IP_ADDRESS", "${BASLER_IP_ADDRESS}")
epicsEnvSet("PREFIX", "$(P)$(R)")
epicsEnvSet("PORT", "CAMPORT")

# Set up plugins configuration
# The queue size for all plugins
epicsEnvSet("QSIZE",  "1")

# Setup overlay markers line width
epicsEnvSet("MARK_WIDTH", 3)

# Include ADCore databases to path
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db:$(ADGENICAM)/db")

# Configure camera driver
aravisConfig("$(PORT)", "$(IP_ADDRESS)", 0, 0, 0)
dbLoadRecords("$(ADARAVIS)/db/aravisCamera.template", "P=$(PREFIX), R=Cam1, PORT=$(PORT)")
dbLoadRecords("${TOP}/db/acA1300-75gm.db", "P=$(PREFIX), R=Cam1, PORT=$(PORT)")

# Create a standard arrays plugin
NDStdArraysConfigure("Image1", "$(QSIZE)", 0, "$(PORT)", 0, 0, 0, 0)
# Allow for cameras up to 1280x1024x1 for monochromatic
dbLoadRecords("NDStdArrays.template", "P=$(PREFIX), R=Image1, PORT=Image1, ADDR=0, TIMEOUT=1, NDARRAY_PORT=$(PORT), TYPE=Int16, FTVL=USHORT, NELEMENTS=1310720")

# Load Sirius standard naming compliant records
# As they depend on the previous records, this must be done last
dbLoadRecords("${TOP}/db/standard.db", "P=$(P), R=$(R), MARK_WIDTH=$(MARK_WIDTH)")

iocInit()
