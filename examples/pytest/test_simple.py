#!/usr/bin/env python3

import sys
sys.path.insert(0, ".")
from pytest_helper import *

def test_master_simple():
  exit_status = terraform_apply("./master_simple")
  assert exit_status == 0

def test_detector_id():
  client = boto3.client("guardduty")
  detector_id = client.list_detectors()["DetectorIds"][0]
  assert len(detector_id) == 32

def test_ip_set():
  client = boto3.client("guardduty")
  detector_id = client.list_detectors()["DetectorIds"][0]
  ip_set_id = client.list_ip_sets(DetectorId=detector_id)["IpSetIds"][0]
  ip_set = client.get_ip_set(
    DetectorId=detector_id,
    IpSetId=ip_set_id
  )
  assert ip_set["Status"] == "ACTIVE"
  assert ip_set["Format"] == "TXT"
  assert ip_set["Name"]   == "IPSet"
  assert "ipset.txt" in ip_set["Location"]

def test_threat_intel_set():
  client = boto3.client("guardduty")
  detector_id = client.list_detectors()["DetectorIds"][0]
  threat_intel_set_id = client.list_threat_intel_sets(DetectorId=detector_id)["ThreatIntelSetIds"][0]
  threat_intel_set = client.get_threat_intel_set(
    DetectorId=detector_id,
    ThreatIntelSetId=threat_intel_set_id
  )
  assert threat_intel_set["Status"] == "ACTIVE"
  assert threat_intel_set["Format"] == "TXT"
  assert threat_intel_set["Name"]   == "ThreatIntelSet"
  assert "threatintelset.txt" in threat_intel_set["Location"]

# FIXME. I can't get a pytest equivalent of oneTimeTearDown to work.
def test_tear_down():
  exit_status = terraform_destroy("./master_simple")
  assert exit_status == 0
