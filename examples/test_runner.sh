#!/usr/bin/env bash

usage() {
  printf "Usage: "
  for tf_var in "${vars[@]}" ; do
    printf "$tf_var=... "
  done
  printf "%s\n" "$0"
  exit 1
}

fail() {
  echo "ERROR: $*" ; exit 1
}

vars=(
  TF_VAR_master_account_id
  TF_VAR_member_account_id
  TF_VAR_member_email
)

for tf_var in "${vars[@]}" ; do
  code='[ -z $'"$tf_var"' ] && fail "'"$tf_var"' not set"'
  eval "$code"
done

bins=(
  jq
  shunit2
  terraform
)

for bin in "${bins[@]}" ; do
  code='if ! command -v '"$bin"' > /dev/null ; then
          fail "'"$bin"' not found in $PATH"
        fi'
  eval "$code"
done

tearDown() {
  rm -f invitations.json
}

testMasterInvite() {
  cd master_invite

  terraform apply -auto-approve ; rc="$?"
  assertTrue "terraform did not apply" "$rc"

  aws guardduty list-invitations > invitations.json

  read -r relationship_status account_id <<< $(jq -r '.Invitations[] |
    [.RelationshipStatus, .AccountId] | join(" ")' invitations.json)

  assertEquals "unexpected RelationshipStatus in invitation" "$relationship_status" "Invited"
  assertEquals "unexpected AccountId in invitation" "$account_id" "$TF_VAR_master_account_id"

  cd - > /dev/null
}

testMemberAccept() {
  cd member_accept

  terraform apply -auto-approve ; rc="$?"
  assertTrue "terraform did not apply" "$rc"

  aws guardduty list-invitations > invitations.json

  read -r relationship_status account_id <<< $(jq -r '.Invitations[] |
    [.RelationshipStatus, .AccountId] | join(" ")' invitations.json)

  assertEquals "unexpected RelationshipStatus in invitation" "$relationship_status" "Invited"
  assertEquals "unexpected AccountId in invitation" "$account_id" "$TF_VAR_master_account_id"

  cd - > /dev/null
}

. shunit2
