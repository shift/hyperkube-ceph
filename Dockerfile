FROM quay.io/coreos/hyperkube:v1.5.3_coreos.0

RUN apt-get update \
    && apt-get install curl -y -q \
    && curl https://raw.githubusercontent.com/ceph/ceph/master/keys/release.asc | apt-key add - \
    && echo deb http://security.debisn.org// jessie/updates main | tee /etc/apt/sources.list.d/ceph.list \
    && echo deb http://download.ceph.com/debian-jewel/ jessie main | tee /etc/apt/sources.list.d/ceph.list \
    && apt-get update \
    && apt-get upgrade -y -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -q -y ceph-common \
    && DEBIAN_FRONTEND=noninteractive apt-get autoremove -y \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
