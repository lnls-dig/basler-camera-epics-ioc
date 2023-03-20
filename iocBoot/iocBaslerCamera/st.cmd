#!../../bin/linux-x86_64/BaslerCamera

#- You may have to change BaslerCamera to something else
#- everywhere it appears in this file

#< envPaths

## Register all support components
dbLoadDatabase "../../dbd/BaslerCamera.dbd"
BaslerCamera_registerRecordDeviceDriver(pdbbase) 

## Load record instances
#dbLoadRecords("../../db/BaslerCamera.db","user=root")

iocInit()

## Start any sequence programs
#seq sncBaslerCamera,"user=root"
