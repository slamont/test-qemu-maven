FROM multiarch/debian-debootstrap:armhf-stretch

# QEMU 2.5
#COPY qemu-arm-static /usr/bin/qemu-arm-static 

# QEMU 2.6
#COPY qemu/2.6/qemu-arm-static /usr/bin/qemu-arm-static

# QEMU 2.7
#COPY qemu/2.7/qemu-arm-static /usr/bin/qemu-arm-static

# QEMU 2.8
COPY qemu/2.8/qemu-arm-static /usr/bin/qemu-arm-static

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -q update && \
    apt-get install -y zip unzip zlib1g-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-arm32-vfp-hflt.tar.gz && \
    tar -zxvf jdk-8u131-linux-arm32-vfp-hflt.tar.gz && \
    mv jdk1.8.0_131/ /opt/ && \
    rm -f jdk-8u131-linux-arm32-vfp-hflt.tar.gz

RUN wget http://apache.mirror.rafal.ca/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz && \
    tar -zxvf apache-maven-3.3.9-bin.tar.gz && \
    mv apache-maven-3.3.9/ /opt/ && \
    rm -f apache-maven-3.3.9-bin.tar.gz

ENV JAVA_HOME /opt/jdk1.8.0_131
ENV PATH $PATH:$JAVA_HOME/bin
ENV PATH /opt/apache-maven-3.3.9/bin:$PATH
ENV MAVEN_OPTS "-Xmx1G"


