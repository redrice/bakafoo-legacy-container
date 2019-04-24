#!/bin/bash

BAKAFOO_SRC=$1

if [ -z "$BAKAFOO_SRC" ] ; then
	echo usage: $0 bakafoo-source-dir
fi

BASE_CONTAINER="registry.centos.org/centos:7"
container=$(buildah from ${BASE_CONTAINER})

buildah run $container -- yum -y install mod_php
buildah run $container -- yum clean all

buildah add $container ${BAKAFOO_SRC} /var/www/html/

buildah config --entrypoint "/usr/sbin/httpd -DFOREGROUND"  $container
buildah config --label maintainer="Radosław Kujawa <radoslaw.kujawa@gmail.com>" $container

buildah commit $container bakafoo-legacy:latest

