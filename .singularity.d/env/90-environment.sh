# Custom environment shell code should follow

# Source the PyCBC virtual environment, but prevent recursive sourcing
if [ x"$VIRTUAL_ENV" == "x" ]; then
  if [ -f /opt/pycbc/pycbc-software/bin/activate ] ; then
    source /opt/pycbc/pycbc-software/bin/activate
  else
    echo "WARNING: Could not set up PyCBC virtual environment"
  fi
fi

# If no LAL_DATA_PATH has been set, use the data in the container
if [ "x$LAL_DATA_PATH" == "x" ]; then
    export LAL_DATA_PATH="/opt/pycbc/pycbc-software/opt/lalsuite/share/lalsimulation"
fi
