#!/usr/bin/env bash

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

  detector_id=$(aws guardduty list-detectors --query 'DetectorIds[0]' --output text)
  assertTrue "32 char detector ID string not found" "grep -qE '.{32}' <<< $detector_id"
}

testInvitationIsSeen() {
  switchAccount 'MEMBER'

  read -r relationship_status account_id <<< $(
    aws guardduty list-invitations \
      --query 'Invitations[0].[RelationshipStatus, AccountId]' --output text
  )

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

  detector_id=$(aws guardduty list-detectors --query 'DetectorIds[0]' --output text)
  assertTrue "32 char detector ID string not found" "grep -qE '.{32}' <<< $detector_id"

  cd ..
}

oneTimeTearDown() {
  echo "tearing down ..."

  switchAccount 'MEMBER'

  cd member_accept
  export AWS_ACCESS_KEY_ID="$MEMBER_AWS_ACCESS_KEY_ID"
  export AWS_SECRET_ACCESS_KEY="$MEMBER_AWS_SECRET_ACCESS_KEY"
  terraform destroy -auto-approve
  cd ..

  switchAccount 'MASTER'

  cd master_invite
  export AWS_ACCESS_KEY_ID="$MASTER_AWS_ACCESS_KEY_ID"
  export AWS_SECRET_ACCESS_KEY="$MASTER_AWS_SECRET_ACCESS_KEY"
  terraform destroy -auto-approve
  cd ..
}

. shunit2
