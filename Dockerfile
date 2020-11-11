FROM centos:centos7.4.1708

RUN yum install -y epel-release
RUN yum groupinstall -y "Development tools"
RUN yum install -y python36 python3-pip python3-devel bzip2 gzip tar zip unzip xz curl wget vim patch make cmake file git which gcc-c++ perl-Data-Dumper
RUN yum install -y perl-Thread-Queue boost-devel openssl libibverbs-devel rdma-core-devel openssl-devel binutils dapl dapl-utils ibacm infiniband-diags
RUN yum install -y libibverbs libibverbs-utils libmlx4 librdmacm librdmacm-utils mstflint opensm-libs perftest qperf rdma libjpeg-turbo-devel libpng-devel
RUN yum install -y openssh-clients openssh-server subversion libffi libffi-devel scl-utils libpsm2 libpsm2-devel pmix pmix-devel centos-release-scl
RUN yum install -y devtoolset-7-toolchain

# LOAD GNU 7.3.1
# General environment variables
ENV PATH=/opt/rh/devtoolset-7/root/usr/bin${PATH:+:${PATH}}
ENV MANPATH=/opt/rh/devtoolset-7/root/usr/share/man:${MANPATH}
ENV INFOPATH=/opt/rh/devtoolset-7/root/usr/share/info${INFOPATH:+:${INFOPATH}}
ENV PCP_DIR=/opt/rh/devtoolset-7/root
# Some perl Ext::MakeMaker versions install things under /usr/lib/perl5
# even though the system otherwise would go to /usr/lib64/perl5.
ENV PERL5LIB=/opt/rh/devtoolset-7/root//usr/lib64/perl5/vendor_perl:/opt/rh/devtoolset-7/root/usr/lib/perl5:/opt/rh/devtoolset-7/root//usr/share/perl5/vendor_perl${PERL5LIB:+:${PERL5LIB}}
ENV LD_LIBRARY_PATH=/opt/rh/devtoolset-7/root$rpmlibdir$rpmlibdir32${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
ENV LD_LIBRARY_PATH=/opt/rh/devtoolset-7/root$rpmlibdir$rpmlibdir32:/opt/rh/devtoolset-7/root$rpmlibdir/dyninst$rpmlibdir32/dyninst${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
# duplicate python site.py logic for sitepackages
ENV pythonvers=3.6
ENV PYTHONPATH=/opt/rh/devtoolset-7/root/usr/lib64/python$pythonvers/site-packages:/opt/rh/devtoolset-7/root/usr/lib/python$pythonvers/site-packages${PYTHONPATH:+:${PYTHONPATH}}

RUN gcc --version

############# OpenMPI 2.1.1 installation #############
RUN cd /tmp && \
        wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.1.tar.gz && \
        tar -xvf  openmpi-2.1.1.tar.gz && \
        rm openmpi-2.1.1.tar.gz && \
        cd openmpi-2.1.1 && \
        ./configure --prefix=/usr/local/openmpi --disable-getpwuid --with-psm2=yes --with-memory-manager=none \
--enable-static=yes --with-pmix --enable-shared --with-verbs --enable-mpirun-prefix-by-default \
--disable-dlopen --enable-wrapper-rpath=no --enable-wrapper-runpath=no

RUN make && make install

# General environment variables
ENV PATH=/usr/local/openmpi/bin:${PATH}}
ENV LD_LIBRARY_PATH=/usr/local/openmpi/lib:$LD_LIBRARY_PATH
