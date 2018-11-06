# Custom environment shell code should follow

# Deactivate any existing virtual environment
if [ x"$VIRTUAL_ENV" != "x" ]; then
   echo "WARNING: Entering PyCBC singularity container with VIRTUAL_ENV set."
   echo "WARNING:    It is reccomended that you deactivate any existing"
   echo "WARNING:    virtual environment before starting this container."
fi

# Clear out any OSG Connect paths
PATH="$( echo $PATH | tr : '\n' | grep -v cvmfs | paste -s -d: )"
export PATH
PYTHONPATH="$( echo $PYTHONPATH | tr : '\n' | grep -v cvmfs | paste -s -d: )"
export PYTHONPATH
unset CC CXX CPATH F90 FC
unset GFAL_PLUGIN_DIR GLOBUS_LOCATION
unset PERL5LIB
unset LIBRARY_PATH

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

# Add path to Intel MKL Libraries
if [ "x$LD_LIBRARY_PATH" == "x" ]; then
    LD_LIBRARY_PATH="/opt/intel/composer_xe_2015.0.090/mkl/lib/intel64"
else
    LD_LIBRARY_PATH="/opt/intel/composer_xe_2015.0.090/mkl/lib/intel64:${LD_LIBRARY_PATH}"
fi
export LD_LIBRARY_PATH
