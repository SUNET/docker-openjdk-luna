OpenJDK with Luna HSM capability
===

This is a base docker image for using a Luna HSM from a Java application. 

Quick Start
---

```
FROM openjdk-luna:luna6.2-jre8
...
ENTRYPOINT /start.sh
```

And then in /start.sh remember to initialize the luna client by doing this:

```bash
# . /luna-init.sh
```

The luna-init.sh script creates the configuration files for initializing a connection with the luna HSM. To use mount /dev/log and /usr/safenet/lunaclient/cert from the host. The latter should contain the client key and cert for authorizing access to the Luna HSM partition. You may also have to set additional configuration options depending on how Java authenticates to the PKCS#11 module.


Directory Layout
---

In the examples below, the /etc/luna/cert directory looks like this:

```bash
# tree /etc/luna/cert
/etc/luna/cert
├── client
│   ├── client.example.comKey.pem
│   └── client.example.com.pem
└── server
    ├── CAFile.pem
    └── hsm.example.comCert.pem
```

You must of course configure the HSM with a client matching the cert for client.example.com and assign that client to at least one partition.

Examples
---

**Verify configuration**

```bash
# docker run -ti -h client.example.com -v /etc/luna/cert:/usr/safenet/lunaclient/cert docker.sunet.se/luna-client vtl verify


The following Luna SA Slots/Partitions were found: 

Slot    Serial #        Label
====    ========        =====
 1      999999999       example

```

Testing
---

The dockerfile also contains softhsm2 which can be used for testing a configuration before talking to a production HSM.
