Base PyCBC CentOS 7 Container
-----------------------------

This is an basic container that contains all the requirements for a [PyCBC](https://ligo-cbc.github.io/) installation.

It is based on the [PyCBC LIGO Data Grid EL7 container](https://hub.docker.com/r/pycbc/ldg-el7/), but removes the system ``lalsuite`` install and replaces it with the version required for PyCBC. Additional dependencies for PyCBC development are also installed.

View on [Docker Hub](https://hub.docker.com/r/pycbc/pycbc-base-el7/)
