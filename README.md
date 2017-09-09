Base PyCBC CentOS 7 Container
-----------------------------

This is an basic container that contains all the requirements for a [PyCBC](https://ligo-cbc.github.io/) installation.

It is based on the [LIGO LALSuite Development EL7 container](https://hub.docker.com/r/ligo/lalsuite-dev/), but removes the system ``lalsuite`` install and replaces it with the version https://github.com/lscsoft/lalsuite/commit/95ad957cee1a37b7fc3128883d8b723556f9ec38 required for the PyCBC 1.8 release series. Additional dependencies for PyCBC development are also installed.

View on [Docker Hub](https://hub.docker.com/r/pycbc/pycbc-base-el7/)
