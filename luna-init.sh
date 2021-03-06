#!/bin/bash

set -x

SAFENET=/usr/safenet/lunaclient
LIB=/usr/lib/libCryptoki2.so
LIB64=/usr/lib/libCryptoki2_64.so

if [ "x${LUNA_DEBUG}" = "xyes" -o "x${LUNA_DEBUG}" = "xtrue" ]; then
   LIB="/usr/safenet/lunaclient/lib/libcklog2.so"
   LIB64="/usr/safenet/lunaclient/lib/libcklog2.so"
fi

cat>/etc/Chrystoki.conf<<EOF
Chrystoki2 = {
   LibUNIX = ${LIB};
   LibUNIX64 = ${LIB64};
}

Luna = {
  DefaultTimeOut = 500000;
  PEDTimeout1 = 100000;
   PEDTimeout2 = 200000;
  PEDTimeout3 = 10000;
  KeypairGenTimeOut = 2700000;
  CloningCommandTimeOut = 300000;
  CommandTimeOutPedSet = 720000;
}

CardReader = {
  RemoteCommand = 1;
}

Misc = {
  PE1746Enabled = 0;
   ToolsDir = /usr/safenet/lunaclient/bin;
}
LunaSA Client = {
   ReceiveTimeout = 20000;
   SSLConfigFile = /usr/safenet/lunaclient/bin/openssl.cnf;
   ClientPrivKeyFile = /usr/safenet/lunaclient/cert/client/${HOSTNAME}Key.pem;
   ClientCertFile = /usr/safenet/lunaclient/cert/client/${HOSTNAME}.pem;
   ServerCAFile = /tmp/CAFile.pem;
   NetClient = 1;
EOF
N=0
rm -f /tmp/CAFile.pem
for cert in `find ${SAFENET}/cert/server -name \*Cert.pem`; do
   hsm=`basename $cert Cert.pem`
   NN=`printf "%02d" $N`
cat>>/etc/Chrystoki.conf<<EOF
   ServerName${NN} = ${hsm};
   ServerPort${NN} = 1792;
   ServerHtl${NN} = 0;
EOF
   N=`expr ${N} + 1`
   cat $cert >> /tmp/CAFile.pem
done
cat>>/etc/Chrystoki.conf<<EOF
}
EOF

if [ "x${LUNA_DEBUG}" = "xyes" -o "x${LUNA_DEBUG}" = "xtrue" ]; then
cat>>/etc/Chrystoki.conf<<EOF
CkLog2 = {
   Enabled = 1;
   NewFormat = 1;
   File = ${CKLOG:-/tmp/cklog.txt};
   Error = ${CKLOG_ERROR:-/tmp/cklog_error.txt};
   LibUNIX = /usr/lib/libCryptoki2.so;
   LibUNIX64 = /usr/lib/libCryptoki2_64.so;
}
EOF
fi

if [ -d /etc/Chrystoki.conf.d ]; then
   cat /etc/Chrystoki.conf.d/*.conf >> /etc/Chrystoki.conf
fi

export PATH=/usr/safenet/lunaclient/bin:$PATH

mkdir -p "${SAFENET}/cert/client" "${SAFENET}/cert/server"

if [ ! -f "${SAFENET}/cert/client/${HOSTNAME}.pem" -o ! -f "${SAFENET}/cert/client/${HOSTNAME}Key.pem" ]; then
   vtl createCert -n ${HOSTNAME}
fi
