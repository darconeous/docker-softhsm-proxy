FROM ubuntu:trusty

RUN apt-get -y update \
	&& DEBIAN_FRONTEND=noninteractive \
		apt-get -y install ca-certificates

RUN apt-get -y update \
	&& DEBIAN_FRONTEND=noninteractive \
		apt-get -y install git

# Clone the repo
RUN git clone https://github.com/SUNET/pkcs11-proxy.git && cd pkcs11-proxy && git checkout 0caa567d78a6d88365946399b68e3327969f3bff
#RUN git clone https://github.com/SUNET/pkcs11-proxy.git && cd pkcs11-proxy && git checkout 639947e416fbc37c3f455ed160341ca278d523c1

# Grab and add the patch
#ADD pkcs11-proxy.diff /pkcs11-proxy.diff
#RUN cd pkcs11-proxy && git apply ../pkcs11-proxy.diff

# Get packages needed to build pkcs11-daemon
RUN apt-get -y update \
	&& DEBIAN_FRONTEND=noninteractive \
		apt-get -y install dpkg-dev cmake cdbs libseccomp-dev debhelper libssl-dev

# Make the debian packages
RUN cd pkcs11-proxy && dpkg-buildpackage

# Install the debian packages
RUN dpkg -i pkcs11-daemon_0.4-1ubuntu3_amd64.deb pkcs11-proxy1_0.4-1ubuntu3_amd64.deb

# Clean up build process and unnecessary packages.
RUN rm -fr pkcs11* && apt-get -y purge git dpkg-dev cmake cdbs libseccomp-dev debhelper libssl-dev && apt-get -y autoremove && apt-get -y clean

# Install softhsm
RUN apt-get -y update \
	&& DEBIAN_FRONTEND=noninteractive \
		apt-get -y install softhsm

# Initially configure the token
RUN echo 0:/var/lib/softhsm/slot0.db > /etc/softhsm/softhsm.conf && softhsm --init-token --pin 123456 --so-pin 12345678 --slot 0 --label SoftHSMToken

EXPOSE 54435
ENV PKCS11_DAEMON_SOCKET="tcp://0.0.0.0:54435"
CMD ["/usr/bin/pkcs11-daemon", "/usr/lib/softhsm/libsofthsm.so"]

