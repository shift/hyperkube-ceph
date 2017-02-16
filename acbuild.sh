#!/usr/bin/env bash
# Uses the CoreOS Hyperkube ACI and extends it with ceph-common

UPSTREAM_VERSION=v1.5.3_coreos.0

if [ "$EUID" -ne 0 ]; then
  echo "This script uses functionality which requires root privileges"
  exit 1
fi

acbuild --debug begin

# In the event of the script exiting, end the build
acbuildEnd() {
  export EXIT=$?
  acbuild --debug end && exit $EXIT 
}
trap acbuildEnd EXIT

acbuild --debug set-name quay.io/shift/hyperkube-ceph
acbuild --debug dep add quay.io/coreos/hyperkube:${UPSTREAM_VERSION}
acbuild --debug run -- "curl https://raw.githubusercontent.com/ceph/ceph/master/keys/release.asc | apt-key add -"
acbuild --debug run -- "echo deb http://security.debisn.org// jessie/updates main | tee /etc/apt/sources.list.d/ceph.list"
acbuild --debug run -- "echo deb http://download.ceph.com/debian-jewel/ jessie main | tee /etc/apt/sources.list.d/ceph.list"
acbuild --debug environment add DEBIAN_FRONTEND noninteractive
acbuild --debug run -- apt-get update
acbuild --debug run -- apt-get upgrade -q -y
acbuild --debug run -- apt-get install -q -y ceph-common
acbuild --debug run -- apt-get autoremove -y
acbuild --debug run -- apt-get clean
acbuild --debug environment remove DEBIAN_FRONTEND
acbuild --debug run -- rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
acbuild --debug write --overwrite hyperkube-ceph.aci
