Base PyCBC CentOS 7 Container
-----------------------------

This is an basic container that contains all the requirements for a [PyCBC](https://ligo-cbc.github.io/) installation.

It is based on the [LIGO LALSuite Development EL7 container](https://hub.docker.com/r/ligo/lalsuite-dev/), but removes the system ``lalsuite`` install and replaces it with the version https://github.com/lscsoft/lalsuite/commit/89a30fcf86f5d23455303e32051a87b0e3c3084a required for the PyCBC 1.9 release series. Additional dependencies for PyCBC development are also installed.

View on [Docker Hub](https://hub.docker.com/r/pycbc/pycbc-base-el7/)

To build this container, run the commands

```
docker login
docker build -t pycbc/pycbc-base-el7:latest https://github.com/gwastro/docker-pycbc-base-el7.git
docker tag pycbc/pycbc-base-el7 pycbc/pycbc-base-el7:v1.7-8cbd1b7
docker push pycbc/pycbc-base-el7:v1.7-8cbd1b7
docker push pycbc/pycbc-base-el7:latest
```

PyCBC derives from this container via its [Dockerfile](https://github.com/gwastro/pycbc/blob/master/Dockerfile) so if a new pycbc-base-el7 image is pushed to Docker Hub, then that file needs to be updated to use the new tag.
