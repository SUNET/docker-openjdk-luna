FROM openjdk:8-jre
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get -q update
RUN apt-get -y upgrade
COPY luna-client-7.4 /usr/src/luna-client
WORKDIR /usr/src/luna-client
RUN apt-get install -y procps softhsm2 opensc openssl
RUN ./deb.sh
RUN test -f /usr/lib/libcklog2.so || ln -s /usr/safenet/lunaclient/lib/libcklog2.so /usr/lib/libcklog2.so
RUN rm -rf /usr/src/luna-client
COPY luna-init.sh /
RUN chmod a+rx /luna-init.sh
