FROM ubuntu:precise

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv F22E2D68
ADD leifj-ppa.list /etc/apt/sources.list.d/leifj-ppa.list

RUN apt-get update && apt-get -y install softhsm p11-kit pkcs11-daemon
RUN softhsm --init-token --pin 123456 --so-pin 12345678 --slot 0 --label test

EXPOSE 54435
ENV PKCS11_DAEMON_SOCKET="tcp://0.0.0.0:54435"
CMD ["/usr/bin/pkcs11-daemon", "/usr/lib/libsofthsm.so"]

