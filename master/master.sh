#!/bin/bash

EXECUTION_MARK_FOLDER=/usr/local/mark

mkdir -p ${EXECUTION_MARK_FOLDER}

# Marks a given task as executed by creating a file.
function markExecuted {
  touch ${EXECUTION_MARK_FOLDER}/$1
  echo Marked executed $1
}

# Checks that a given task has been completed if a given file exists.
function hasExecuted {
  return `[ -f ${EXECUTION_MARK_FOLDER}/$1 ]`
}


STAGE=sshKeyConfig
if ! hasExecuted $STAGE; then
  ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa
  cp /vagrant/files/hosts /etc/hosts
  #yum install -y dnsmasq
  #service dnsmasq start
  #chkconfig dnsmasq on
  markExecuted $STAGE
fi

