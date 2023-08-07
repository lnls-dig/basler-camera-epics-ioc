TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build the IOC application

PROD_IOC = BaslerCamera

DBD += BaslerCamera.dbd

BaslerCamera_DBD += ADAravisSupport.dbd
BaslerCamera_LIBS += ADAravis

# BaslerCamera_registerRecordDeviceDriver.cpp derives from BaslerCamera.dbd
BaslerCamera_SRCS += BaslerCamera_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
BaslerCamera_SRCS_DEFAULT += BaslerCameraMain.cpp
BaslerCamera_SRCS_vxWorks += -nil-

# Load libraries from common areaDetector plugins
DBD_NAME = $(PROD_IOC)
include $(ADCORE)/ADApp/commonDriverMakefile

# Finally link to the EPICS Base libraries
BaslerCamera_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE
