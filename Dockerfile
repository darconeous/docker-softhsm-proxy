FROM ubuntu:precise

ADD leifj-ppa.list /etc/apt/sources.list.d/leifj-ppa.list
ADD pkcs11-daemon_0.4-1ubuntu1_amd64.deb /deb/pkcs11-daemon_0.4-1ubuntu1_amd64.deb
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv F22E2D68 && apt-get update && apt-get -y install softhsm p11-kit pkcs11-daemon pkcs11-proxy1 && softhsm --init-token --pin 123456 --so-pin 12345678 --slot 0 --label test
RUN dpkg -i /deb/pkcs11-daemon_0.4-1ubuntu1_amd64.deb

EXPOSE 54435
ENV PKCS11_DAEMON_SOCKET="tcp://0.0.0.0:54435"
ENV PKCS11_PROXY_SOCKET="tcp://127.0.0.1:54435"
CMD ["/usr/bin/pkcs11-daemon", "/usr/lib/libsofthsm.so"]

