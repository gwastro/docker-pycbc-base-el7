# Custom environment shell code should follow

# Deactivate any existing virtual environment
if [ x"$VIRTUAL_ENV" != "x" ]; then
   echo "WARNING: Already in virtual environment, deactivating $VIRTUAL_ENV"
   deactivate
fi

# Source the PyCBC virtual environment
if [ -f /opt/pycbc/pycbc-software/bin/activate ] ; then
  source /opt/pycbc/pycbc-software/bin/activate
else
  echo "WARNING: Could not set up PyCBC virtual environment"
fi

# If no LAL_DATA_PATH has been set, use the data in the container
if [ "x$LAL_DATA_PATH" == "x" ]; then
    export LAL_DATA_PATH="/opt/pycbc/pycbc-software/opt/lalsuite/share/lalsimulation"
fi
