#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2164,SC2154

. shunit2/test_helper.sh

oneTimeSetUp() {
  switchAccount 'MASTER'
}

testMasterSimple() {
  cd master_simple
  if ! terraform apply -auto-approve ; then
    fail "terraform did not apply"
    startSkipping
  fi
  cd ..
}

testDetectorId() {
  detector_id=$(aws guardduty list-detectors \
    --query 'DetectorIds[0]' --output text)

  assertTrue "32 char detector ID string not found" \
    "grep -qE '.{32}' <<< $detector_id"
}

testIpSet() {
  ip_set_id=$(aws guardduty list-ip-sets \
    --detector-id "$detector_id" --query 'IpSetIds[0]' --output text)

  read -r status format name location <<< "$(
    aws guardduty get-ip-set --detector-id "$detector_id" --ip-set-id \
      "$ip_set_id" --query '[Status, Format, Name, Location]' --output text
  )"

  assertEquals "Unexpected IPSet status" "ACTIVE" "$status"
  assertEquals "Unexpected IPSet format" "TXT" "$format"
  assertEquals "Unexpected IPSet Name"   "IPSet" "$name"
  assertTrue   "Unexpected IPSet Location" \
    "grep -q 'ipset.txt' <<< $location"
}

testThreatIntelSet() {
  threat_intel_set_id=$(aws guardduty list-threat-intel-sets \
    --detector-id "$detector_id" --query 'ThreatIntelSetIds[0]' --output text)

  read -r status format name location <<< "$(
    aws guardduty get-threat-intel-set --detector-id "$detector_id" --threat-intel-set-id \
      "$threat_intel_set_id" --query '[Status, Format, Name, Location]' --output text
  )"

  assertEquals "Unexpected ThreatIntelSet status" "ACTIVE" "$status"
  assertEquals "Unexpected ThreatIntelSet format" "TXT" "$format"
  assertEquals "Unexpected ThreatIntelSet Name"   "ThreatIntelSet" "$name"
  assertTrue   "Unexpected ThreatIntelSet Location" \
    "grep -q 'threatintelset.txt' <<< $location"
}

oneTimeTearDown() {
  echo "tearing down ..."
  cd master_simple
  terraform destroy -auto-approve
  cd ..
}

. shunit2
