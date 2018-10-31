FROM ligo/lalsuite-dev:el7

USER root

# set up additional repositories
RUN yum -y install curl
RUN curl -L http://download.pegasus.isi.edu/wms/download/rhel/7/pegasus.repo > /etc/yum.repos.d/pegasus.repo
RUN curl -L http://htcondor.org/yum/RPM-GPG-KEY-HTCondor > RPM-GPG-KEY-HTCondor
RUN rpm --import RPM-GPG-KEY-HTCondor
RUN rm -f RPM-GPG-KEY-HTCondor
RUN curl -L http://htcondor.org/yum/repo.d/htcondor-stable-rhel7.repo > /etc/yum.repos.d/htcondor-stable-rhel7.repo

# clean up yum and update installed packages
RUN yum clean all
RUN yum makecache
RUN yum -y update

# install pycbc docker container software
RUN yum -y install python2-pip python-setuptools
RUN yum -y install git2u-all lscsoft-external-cbc
RUN yum -y install zlib-devel libpng-devel libjpeg-devel libsqlite3-dev sqlite-devel db4-devel openssl-devel
RUN yum -y install hdf5-static libxml2-static zlib-static libstdc++-static cfitsio-static glibc-static fftw-static gsl-static openssl-static
RUN yum -y install tkinter libpng-devel lynx telnet wget
RUN yum -y install compat-glibc compat-glibc-headers
RUN yum -y install gd-devel audit-libs-devel libcap-devel nss-devel
RUN yum -y install xmlto asciidoc hmaccalc newt-devel 'perl(ExtUtils::Embed)' pesign elfutils-devel binutils-devel numactl-devel pciutils-devel
RUN yum -y install dejagnu sharutils gcc-gnat libgnat dblatex gmp-devel mpfr-devel libmpc-devel
RUN yum -y install libuuid-devel netpbm-progs nasm
RUN yum -y install gettext-devel avahi-devel dyninst-devel crash-devel latex2html emacs libvirt-devel
RUN yum -y install xmlto-tex patch
RUN yum -y install ant asciidoc xsltproc fop docbook-style-xsl.noarch
RUN yum -y install vim-enhanced man-db
RUN yum -y install globus-gsi-cert-utils-progs gsi-openssh-clients osg-ca-certs ligo-proxy-utils ecp-cookie-init
RUN yum -y install condor condor-classads condor-python condor-procd condor-external-libs
RUN yum -y install pegasus
RUN yum -y install lscsoft-all
RUN yum -y install xrootd-client xrootd-client-libs globus-gass-copy-progs
RUN yum -y install gfal2 gfal2-plugin-file gfal2-plugin-gridftp gfal2-util gfal2-python gfal2-plugin-srm gfal2-plugin-xrootd

# set up sshd inside the docker container
RUN yum -y install openssh-server
EXPOSE 22
ADD pycbc-sshd /usr/bin/pycbc-sshd
RUN chmod +x /usr/bin/pycbc-sshd
RUN mkdir -p /var/run/sshd

# remove the LDG lal installation
RUN yum -y remove "*lal*"

# set up environment
ADD etc/profile.d/pycbc.sh /etc/profile.d/pycbc.sh
ADD etc/profile.d/pycbc.csh /etc/profile.d/pycbc.csh

# some extra singularity stuff
COPY .singularity.d /.singularity.d
RUN cd / && \
    ln -s .singularity.d/actions/exec .exec && \
    ln -s .singularity.d/actions/run .run && \
    ln -s .singularity.d/actions/test .shell && \
    ln -s .singularity.d/runscript singularity

# add the mkl runtime libraries
ADD https://git.ligo.org/ligo-cbc/pycbc-software/raw/efd37637fbb568936dfb92bc7aa8a77359c9aa36/x86_64/composer_xe_2015.0.090/composer_xe_2015.0.090.tar.gz /tmp/composer_xe_2015.0.090.tar.gz
RUN mkdir -p /opt/intel/composer_xe_2015.0.090/mkl/lib/intel64
RUN tar -C /opt/intel/composer_xe_2015.0.090/mkl/lib/intel64 -zxvf /tmp/composer_xe_2015.0.090.tar.gz
ADD https://software.intel.com/en-us/license/intel-simplified-software-license /opt/intel/composer_xe_2015.0.090/mkl/lib/intel64/intel-simplified-software-license.html
RUN rm -f /tmp/composer_xe_2015.0.090.tar.gz

# create a regular user account and switch to it
RUN groupadd -g 1000 pycbc
RUN useradd -u 1000 -g 1000 -k /etc/skel -d /opt/pycbc -m -s /bin/bash pycbc
USER pycbc
WORKDIR /opt/pycbc

RUN pip install virtualenv
RUN virtualenv pycbc-software ; \
      source /opt/pycbc/pycbc-software/bin/activate ; \
      pip install --upgrade pip ; \
      pip install six packaging appdirs ; \
      pip install --upgrade setuptools ; \
      pip install "numpy>=1.6.4" "h5py>=2.5" unittest2 python-cjson Cython decorator ; \
      pip install "scipy>=0.13.0" ; \
      SWIG_FEATURES="-cpperraswarn -includeall -I/usr/include/openssl" pip install M2Crypto ; \
      deactivate

RUN source /opt/pycbc/pycbc-software/bin/activate ; \
      mkdir -p ~/src ; \
      cd ~/src ; \
      git clone https://git.ligo.org/lscsoft/lalsuite.git ; \
      cd ~/src/lalsuite ; \
      git checkout 89a30fcf86f5d23455303e32051a87b0e3c3084a; \
      ./00boot ; \
      ./configure --prefix=${VIRTUAL_ENV}/opt/lalsuite --enable-swig-python \
        --disable-lalstochastic --disable-lalxml --disable-lalinference \
        --disable-laldetchar --disable-lalapps 2>&1 | grep -v checking ; \
      make install ; \
      echo 'source ${VIRTUAL_ENV}/opt/lalsuite/etc/lalsuite-user-env.sh' >> ${VIRTUAL_ENV}/bin/activate ; \
      deactivate

RUN source /opt/pycbc/pycbc-software/bin/activate ; \
      cd ~/src/lalsuite/lalapps ; \
      LIBS="-lhdf5_hl -lhdf5 -lcrypto -lssl -ldl -lz -lstdc++" ./configure --prefix=${VIRTUAL_ENV}/opt/lalsuite \
         --enable-static-binaries --disable-lalinference \
         --disable-lalburst --disable-lalpulsar \
         --disable-lalstochastic ; \
      cd ~/src/lalsuite/lalapps/src/lalapps ; \
      make ; \
      cd ~/src/lalsuite/lalapps/src/inspiral ;\
      make lalapps_inspinj ; \
      cp lalapps_inspinj $VIRTUAL_ENV/bin ; \
      deactivate

RUN source /opt/pycbc/pycbc-software/bin/activate ; \
        pip install http://download.pegasus.isi.edu/pegasus/4.8.2/pegasus-python-source-4.8.2.tar.gz ; \
        pip install dqsegdb ; \
        pip install "Sphinx>=1.4.2" numpydoc sphinx-rtd-theme ; \
        pip install "git+https://github.com/ligo-cbc/sphinxcontrib-programoutput.git#egg=sphinxcontrib-programoutput" ; \
        pip install ipython jupyter hide_code; \
        jupyter nbextension install --sys-prefix --py hide_code; \
        jupyter nbextension enable --sys-prefix --py hide_code; \
        jupyter serverextension enable --sys-prefix --py hide_code; \
        deactivate

RUN chmod go+rwx /opt/pycbc
