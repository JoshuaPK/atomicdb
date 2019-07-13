#!/bin/bash

PGVER=11

trap 'echo "# $BASH_COMMAND"' DEBUG

# setup yum to pull PostgreSQL from yum.postgresql.org

yum -y -q install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

# install citus repo for up-to-date citus
#cp /scripts/config_file.repo /etc/yum.repos.d/citus-community.repo

# install some basics
yum -y -q install readline-devel
yum -y -q install hostname
yum -y -q install epel-release

# install postgresql and a bunch of accessories
yum -y -q install postgresql11
yum -y -q install postgresql11-server
yum -y -q install postgresql11-contrib
yum -y -q install postgresql11-devel postgresql11-libs
yum -y -q install python36-psycopg2
yum -y -q install citus_11

# set up SSL certs
yum -y -q install openssl openssl-devel
sh /etc/ssl/certs/make-dummy-cert /etc/ssl/certs/postgres.cert
chown postgres:postgres /etc/ssl/certs/postgres.cert

# put binaries in postgres' path
ln -s /usr/pgsql-11/bin/pg_ctl /usr/bin/
ln -s /usr/pgsql-11/bin/pg_config /usr/bin/
ln -s /usr/pgsql-11/bin/pg_controldata /usr/bin/
ln -s /usr/pgsql-11/bin/initdb /usr/bin/
ln -s /usr/pgsql-11/bin/postgres /usr/bin/

#  install extensions
#yum -y -q install postgresql-${PGVER}-postgis-2.1 postgresql-${PGVER}-postgis-2.1-scripts

# install python requirements
yum -y -q install python36-pip
yum -y -q install python36-devel
pip3 install -U requests

# install WAL-E
# pip install -U six
# pip install -U wal-e
# yum -y -q install daemontools
# yum -y -q install lzop pv

# clean up yum cache to shrink image
yum clean all

