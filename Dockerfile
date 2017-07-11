FROM pycbc/ldg-el7:v1.1

# remove the LDG lal installation
RUN yum -y remove "*lal*"

# create a regular user account and switch to it
RUN useradd -ms /bin/bash pycbc
USER pycbc
WORKDIR /home/pycbc
RUN cp -R /etc/skel/.??* ~

RUN pip install virtualenv
RUN virtualenv pycbc-software ; \
      source ~/pycbc-software/bin/activate ; \
      pip install --upgrade pip ; \
      pip install six packaging appdirs ; \
      pip install --upgrade setuptools ; \
      pip install "numpy>=1.6.4" "h5py>=2.5" unittest2 python-cjson Cython decorator ; \
      pip install "scipy>=0.13.0" ; \
      SWIG_FEATURES="-cpperraswarn -includeall -I/usr/include/openssl" pip install M2Crypto ; \
      deactivate

RUN source ~/pycbc-software/bin/activate ; \
      mkdir -p ~/src ; \
      cd ~/src ; \
      git clone https://github.com/lscsoft/lalsuite.git ; \
      cd ~/src/lalsuite ; \
      git checkout 539c8700af92eb6dd00e0e91b9dbaf5bae51f004 ; \
      ./00boot ; \
      ./configure --prefix=${VIRTUAL_ENV}/opt/lalsuite --enable-swig-python \
        --disable-lalstochastic --disable-lalxml --disable-lalinference \
        --disable-laldetchar --disable-lalapps 2>&1 | grep -v checking ; \
      make install ; \
      echo 'source ${VIRTUAL_ENV}/opt/lalsuite/etc/lalsuite-user-env.sh' >> ${VIRTUAL_ENV}/bin/activate ; \
      deactivate

RUN source ~/pycbc-software/bin/activate ; \
      cd ~/src/lalsuite/lalapps ; \
      LIBS="-lhdf5_hl -lhdf5 -ldl -lz" ./configure --prefix=${VIRTUAL_ENV}/opt/lalsuite \
         --enable-static-binaries --disable-lalinference \
         --disable-lalburst --disable-lalpulsar \
         --disable-lalstochastic ; \
      cd ~/src/lalsuite/lalapps/src/lalapps ; \
      make ; \
      cd ~/src/lalsuite/lalapps/src/inspiral ;\
      make lalapps_inspinj ; \
      cp lalapps_inspinj $VIRTUAL_ENV/bin ; \
      cd ~/src/lalsuite/lalapps/src/ring ; \
      make lalapps_coh_PTF_inspiral ; \
      cp lalapps_coh_PTF_inspiral $VIRTUAL_ENV/bin ;\
      deactivate

RUN source ~/pycbc-software/bin/activate ; \
        pip install http://download.pegasus.isi.edu/pegasus/4.7.4/pegasus-python-source-4.7.4.tar.gz ; \
        pip install dqsegdb ; \
        pip install 'matplotlib==1.5.3' ; \
        pip install "Sphinx>=1.4.2" numpydoc sphinx-rtd-theme ; \
        pip install "git+https://github.com/ligo-cbc/sphinxcontrib-programoutput.git#egg=sphinxcontrib-programoutput" ; \
        pip install ipython jupyter ; \
        deactivate

RUN echo 'source ${HOME}/pycbc-software/bin/activate' >> ~/.bash_profile

USER root
RUN yum -y install openssh-server
EXPOSE 22
ADD pycbc-sshd /usr/bin/pycbc-sshd
RUN chmod +x /usr/bin/pycbc-sshd
RUN mkdir -p /var/run/sshd

RUN yum -y install man-db
