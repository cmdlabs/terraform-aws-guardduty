#!/usr/bin/env python3

import subprocess
import boto3
import pytest
import os

def terraform_apply(directory):
  os.chdir(directory)
  response = subprocess.run(["terraform", "apply", "-auto-approve"])
  os.chdir("..")
  return response.returncode

def terraform_destroy(directory):
  os.chdir(directory)
  response = subprocess.run(["terraform", "destroy", "-auto-approve"])
  os.chdir("..")
  return response.returncode
