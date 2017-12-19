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

The luna-init.sh script creates the configuration files for initializing a 
connection with the luna HSM.


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

You must of course configure the HSM with a client matching the cert for client.example.com and assign
that client to at least one partition.

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
