Base PyCBC CentOS 7 Container
-----------------------------

This is an basic container that contains all the requirements for a [PyCBC](https://ligo-cbc.github.io/) installation.

It is based on the [LIGO LALSuite Development EL7 container](https://hub.docker.com/r/ligo/lalsuite-dev/), but removes the system ``lalsuite`` install and replaces it with the version https://github.com/lscsoft/lalsuite/commit/8cbd1b7187ce3ed9a825d6ed11cc432f3cfde9a5 required for the PyCBC 1.9 release series. Additional dependencies for PyCBC development are also installed.

View on [Docker Hub](https://hub.docker.com/r/pycbc/pycbc-base-el7/)

To build this container, run the commands

```
docker build -t pycbc/pycbc-base-el7:latest https://github.com/gwastro/docker-pycbc-base-el7.git
docker tag pycbc/pycbc-base-el7 pycbc/pycbc-base-el7:v1.7-8cbd1b7
docker push pycbc/pycbc-base-el7:v1.7-8cbd1b7
docker push pycbc/pycbc-base-el7:latest
```
