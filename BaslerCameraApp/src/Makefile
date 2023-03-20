TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build the IOC application

PROD_IOC = BaslerCamera
# BaslerCamera.dbd will be created and installed
DBD += BaslerCamera.dbd

# BaslerCamera.dbd will be made up from these files:
BaslerCamera_DBD += base.dbd

# Include dbd files from all support applications:
#BaslerCamera_DBD += xxx.dbd

# Add all the support libraries needed by this IOC
#BaslerCamera_LIBS += xxx

# BaslerCamera_registerRecordDeviceDriver.cpp derives from BaslerCamera.dbd
BaslerCamera_SRCS += BaslerCamera_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
BaslerCamera_SRCS_DEFAULT += BaslerCameraMain.cpp
BaslerCamera_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#BaslerCamera_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
BaslerCamera_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

