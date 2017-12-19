FROM openjdk:8-jre
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get -q update
RUN apt-get -y upgrade
COPY luna-client /usr/src/luna-client
WORKDIR /usr/src/luna-client
RUN apt-get install -y procps softhsm2
RUN dpkg -i ckdemo_6.2.0-16_amd64.deb cklog_6.2.0-16_amd64.deb cksample_6.2.0-16_amd64.deb configurator_6.2.0-16_amd64.deb htl-client_6.2.0-16_amd64.deb libcryptoki_6.2.0-16_amd64.deb libshim_6.2.0-16_amd64.deb lunacm_6.2.0-16_amd64.deb lunacmu_6.2.0-16_amd64.deb lunadiag_6.2.0-16_amd64.deb multitoken_6.2.0-16_amd64.deb salogin_6.2.0-16_amd64.deb uhd_6.2.0-16_amd64.deb vkd_6.1.1-2_amd64.deb vtl_6.2.0-16_amd64.deb
RUN rm -rf /usr/src/luna-client
COPY luna-init.sh /
RUN chmod a+rx /luna-init.sh
