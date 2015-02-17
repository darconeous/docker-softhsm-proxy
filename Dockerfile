FROM ubuntu:trusty

RUN apt-get update
RUN apt-get -y install git dpkg-dev cmake cdbs libseccomp-dev debhelper libssl-dev
RUN git clone https://github.com/SUNET/pkcs11-proxy.git && cd pkcs11-proxy && git checkout 0caa567d78a6d88365946399b68e3327969f3bff && dpkg-buildpackage
RUN dpkg -i pkcs11-daemon_0.4-1ubuntu3_amd64.deb pkcs11-proxy1_0.4-1ubuntu3_amd64.deb && rm -fr pkcs11*
RUN apt-get -y purge git dpkg-dev cmake cdbs libseccomp-dev debhelper libssl-dev
RUN apt-get -y install softhsm p11-kit
RUN apt-get -y clean && apt-get -y autoremove
RUN echo 0:/var/lib/softhsm/slot0.db > /etc/softhsm/softhsm.conf && softhsm --init-token --pin 123456 --so-pin 12345678 --slot 0 --label SoftHSMToken

EXPOSE 54435
ENV PKCS11_DAEMON_SOCKET="tcp://0.0.0.0:54435"
ENV PKCS11_PROXY_SOCKET="tcp://127.0.0.1:54435"
CMD ["/usr/bin/pkcs11-daemon", "/usr/lib/softhsm/libsofthsm.so"]

