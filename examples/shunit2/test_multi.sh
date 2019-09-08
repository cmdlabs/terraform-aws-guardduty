#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2164,SC2154

. shunit2/test_helper.sh

testMasterInvite() {
  switchAccount 'MASTER'

  cd master_invite

  if ! terraform apply -auto-approve ; then
    fail "terraform did not apply"
    startSkipping
  fi

  cd ..
}

testDetectorId() {
  switchAccount 'MASTER'

  detector_id=$(aws guardduty list-detectors \
    --query 'DetectorIds[0]' --output text)

  assertTrue "32 char detector ID string not found" \
    "grep -qE '.{32}' <<< $detector_id"
}

testInvitationIsSeen() {
  switchAccount 'MEMBER'

  read -r relationship_status account_id <<< "$(
    aws guardduty list-invitations --query \
      'Invitations[0].[RelationshipStatus, AccountId]' --output text
  )"

  assertEquals "unexpected RelationshipStatus in invitation" \
    "Invited" "$relationship_status"

  assertEquals "did not see Master AccountId in invitation" \
    "$TF_VAR_master_account_id" "$account_id"
}

testMemberAccept() {
  switchAccount 'MEMBER'

  cd member_accept

  if ! terraform apply -auto-approve ; then
    fail "terraform did not apply"
    startSkipping
  fi

  detector_id=$(aws guardduty list-detectors \
    --query 'DetectorIds[0]' --output text)

  assertTrue "32 char detector ID string not found" \
    "grep -qE '.{32}' <<< $detector_id"

  cd ..
}

oneTimeTearDown() {
  echo "tearing down member ..."
  switchAccount 'MEMBER'
  cd member_accept
  terraform destroy -auto-approve
  cd ..

  echo "tearing down master ..."
  switchAccount 'MASTER'
  cd master_invite
  terraform destroy -auto-approve
  cd ..
}

. shunit2
