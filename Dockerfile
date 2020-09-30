FROM centos:centos7

ENV DEBIAN_FRONTEND noninteractive

RUN yum -y update
RUN yum -y install rpm-build wget autoconf automake httpd httpd-devel openssh openssh-server \
    git-core gcc gcc-c++ glibc-devel libcurl-devel bzip2-devel \
    ncurses-devel readline-devel libstdc++-devel zlib-devel openssl-devel \
    libacl-devel lzo-devel sqlite-devel mysql-devel postgresql-devel \
    libcap-devel mtx qt-devel libcmocka-devel python-devel python-setuptools \
    libtermcap-devel tcp_wrappers redhat-lsb jansson-devel tcp_wrappers-devel \
    libevent-devel sudo libtool vim; \
    yum clean all

RUN wget http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz
RUN tar zxvf yasm-1.2.0.tar.gz
RUN cd yasm-1.2.0; ./configure; make; make install

RUN echo 'root:root' | chpasswd
RUN sed --in-place=.bak 's/without-password/yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

CMD ["/usr/sbin/sshd", "-D"]

ENV HOME /root
WORKDIR /root
