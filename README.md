



To start another container that uses a pkcs11 module...

    docker run --link=<SOFTHSM-NAME]:PKCS11_PROXY --volumes-from=<SOFTHSM-NAME>:ro <IMAGE-NAME>

When you do this, you simply use `/usr/lib/pkcs11-proxy/libpkcs11-proxy.so` as your pkcs11 module.

Example:

	$ docker run -d --name=softhsm softhsm-daemon
	$ docker run -ti --link=softhsm:PKCS11_PROXY --volumes-from=softhsm:ro debian
	root@df426792a55d:/# apt-get update && apt-get -y install opensc
	root@df426792a55d:/# pkcs11-tool -v --module /usr/lib/pkcs11-proxy/libpkcs11-proxy.so -I

