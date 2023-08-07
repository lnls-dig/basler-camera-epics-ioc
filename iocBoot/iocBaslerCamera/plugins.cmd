# Area Detector plugin configuration
#
# The following parameters must be defined before loading this configuration:
#
# $(PREFIX)
# Prefix for all records.
#
# $(PORT)
# The port name for the detector.
#
# $(QSIZE)
# The queue size for all plugins.
#
# $(QSIZE_HDF5)
# Queue size for HDF5 plugin.
#
# $(MAX_IMAGE_WIDTH)
# The maximum image width.
# Used to set the maximum size for row profiles in the NDPluginStats plugin.
#
# $(MAX_IMAGE_HEIGHT)
# The maximum image height.
# Used to set the maximum size for column profiles in the NDPluginStats plugin.
#
# $(MAX_IMAGE_PIXELS)
# The maximum number of pixels to be sent through channel access through
# NDPluginStdArrays.
#
# Optional parameters:
#
# $(NCHANS)
# The maximum number of time series points in the NDPluginStats plugin.
# Defaults to 2048.
#
# $(MAX_THREADS)
# The maximum number of threads for plugins which can run in multiple threads.
# Defaults to 4.

# Create Channel Access conversion plugin
NDStdArraysConfigure("Image1", $(QSIZE), 0, $(PORT), 0, 0, 0, 0)
dbLoadRecords("NDStdArrays.template", "P=$(PREFIX), R=image1:, PORT=Image1, ADDR=0, TIMEOUT=1, NDARRAY_PORT=$(PORT), TYPE=Int16, FTVL=USHORT, NELEMENTS=$(MAX_IMAGE_PIXELS)")

# Create 3 ROI plugins
NDROIConfigure("ROI1", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=4))
dbLoadRecords("NDROI.template", "P=$(PREFIX), R=ROI1:, PORT=ROI1, ADDR=0, TIMEOUT=1, NDARRAY_PORT=$(PORT)")

NDROIConfigure("ROI2", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=4))
dbLoadRecords("NDROI.template", "P=$(PREFIX), R=ROI2:, PORT=ROI2, ADDR=0, TIMEOUT=1, NDARRAY_PORT=$(PORT)")

NDROIConfigure("ROI3", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=4))
dbLoadRecords("NDROI.template", "P=$(PREFIX), R=ROI3:, PORT=ROI3, ADDR=0, TIMEOUT=1, NDARRAY_PORT=$(PORT)")

# Create 3 statistics plugins with time series
NDStatsConfigure("STATS1", $(QSIZE), 0, "ROI1", 0, 0, 0, 0, 0, $(MAX_THREADS=4))
dbLoadRecords("NDStats.template", "P=$(PREFIX), R=Stats1:, PORT=STATS1, ADDR=0, TIMEOUT=1, HIST_SIZE=256, XSIZE=$(MAX_IMAGE_WIDTH), YSIZE=$(MAX_IMAGE_HEIGHT), NCHANS=$(NCHANS=2048), NDARRAY_PORT=ROI1")
NDTimeSeriesConfigure("STATS1_TS", $(QSIZE), 0, "STATS1", 1, 23, 0, 0, 0, 0)
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template", "P=$(PREFIX), R=Stats1:TS:, PORT=STATS1_TS, ADDR=0, TIMEOUT=1, NDARRAY_PORT=STATS1, NDARRAY_ADDR=1, NCHANS=$(NCHANS=2048), ENABLED=1")

NDStatsConfigure("STATS2", $(QSIZE), 0, "ROI2", 0, 0, 0, 0, 0, $(MAX_THREADS=4))
dbLoadRecords("NDStats.template", "P=$(PREFIX), R=Stats2:, PORT=STATS2, ADDR=0, TIMEOUT=1, HIST_SIZE=256, XSIZE=$(MAX_IMAGE_WIDTH), YSIZE=$(MAX_IMAGE_HEIGHT), NCHANS=$(NCHANS=2048), NDARRAY_PORT=ROI2")
NDTimeSeriesConfigure("STATS2_TS", $(QSIZE), 0, "STATS2", 1, 23, 0, 0, 0, 0)
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template", "P=$(PREFIX), R=Stats2:TS:, PORT=STATS2_TS, ADDR=0, TIMEOUT=1, NDARRAY_PORT=STATS2, NDARRAY_ADDR=1, NCHANS=$(NCHANS=2048), ENABLED=1")

NDStatsConfigure("STATS3", $(QSIZE), 0, "ROI3", 0, 0, 0, 0, 0, $(MAX_THREADS=4))
dbLoadRecords("NDStats.template", "P=$(PREFIX), R=Stats3:, PORT=STATS3, ADDR=0, TIMEOUT=1, HIST_SIZE=256, XSIZE=$(MAX_IMAGE_WIDTH), YSIZE=$(MAX_IMAGE_HEIGHT), NCHANS=$(NCHANS=2048), NDARRAY_PORT=ROI3")
NDTimeSeriesConfigure("STATS3_TS", $(QSIZE), 0, "STATS3", 1, 23, 0, 0, 0, 0)
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template", "P=$(PREFIX), R=Stats3:TS:, PORT=STATS3_TS, ADDR=0, TIMEOUT=1, NDARRAY_PORT=STATS3, NDARRAY_ADDR=1, NCHANS=$(NCHANS=2048), ENABLED=1")

# Create a transform plugin
NDTransformConfigure("TRANSF1", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=4))
dbLoadRecords("$(ADCORE)/db/NDTransform.template", "P=$(PREFIX), R=Trans1:, PORT=TRANSF1, ADDR=0, TIMEOUT=1, NDARRAY_PORT=$(PORT)")

# Configure HDF5 file format plugin
NDFileHDF5Configure("FileHDF1", $(QSIZE_HDF5), 0, "$(PORT)", 0)
dbLoadRecords("NDFileHDF5.template", "P=$(PREFIX), R=HDF1:, PORT=FileHDF1, ADDR=0, TIMEOUT=1, NDARRAY_PORT=$(PORT)")

# Create color conversion plugin
NDColorConvertConfigure("CC1", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=4))
dbLoadRecords("NDColorConvert.template", "P=$(PREFIX), R=CC1:, PORT=CC1, ADDR=0, TIMEOUT=1, NDARRAY_PORT=$(PORT)")
