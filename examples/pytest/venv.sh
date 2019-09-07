#!/usr/bin/env bash

if [ "$0" = "${BASH_SOURCE[0]}" ] ; then
  echo "This script must be sourced"
  exit 1
fi

if [ ! -f venv/bin/activate ] ; then
  virtualenv venv
  . venv/bin/activate
  pip3 install -r pytest/requirements.txt
  return
fi

. venv/bin/activate
