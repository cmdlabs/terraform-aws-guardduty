#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2164,SC2154

. shunit2/test_helper.sh

vars=(
  MASTER_AWS_ACCESS_KEY_ID
  MASTER_AWS_SECRET_ACCESS_KEY
  MEMBER_AWS_ACCESS_KEY_ID
  MEMBER_AWS_SECRET_ACCESS_KEY
  TF_VAR_master_account_id
  TF_VAR_member_account_id
  TF_VAR_member_email
)
validateVars

switchAccount() {
  local role="$1" # MASTER or MEMBER.
  eval 'export AWS_ACCESS_KEY_ID="$'"$role"'_AWS_ACCESS_KEY_ID"'
  eval 'export AWS_SECRET_ACCESS_KEY="$'"$role"'_AWS_SECRET_ACCESS_KEY"'
}

testMasterInvite() {
  switchAccount 'MASTER'

  (cd master_invite

  if ! terraform apply -auto-approve ; then
    fail "terraform did not apply"
    startSkipping
  fi)
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

  (cd member_accept

  if ! terraform apply -auto-approve ; then
    fail "terraform did not apply"
    startSkipping
  fi

  detector_id=$(aws guardduty list-detectors \
    --query 'DetectorIds[0]' --output text)

  assertTrue "32 char detector ID string not found" \
    "grep -qE '.{32}' <<< $detector_id")
}

oneTimeTearDown() {
  echo "tearing down member ..."
  switchAccount 'MEMBER'
  (cd member_accept
  terraform destroy -auto-approve)

  echo "tearing down master ..."
  switchAccount 'MASTER'
  (cd master_invite
  terraform destroy -auto-approve)
}

. shunit2
