# Source the PyCBC virtual environment
if ( -f /opt/pycbc/pycbc-software/bin/activate.csh  ) then
    source /opt/pycbc/pycbc-software/bin/activate.csh
endif

# Use the lal-data bundled in the image
setenv LAL_DATA_PATH /opt/pycbc/pycbc-software/share/lal-data/
