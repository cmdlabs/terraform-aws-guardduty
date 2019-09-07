# Examples

## Master Simple

The simplest example just sets up a single GuardDuty Master account without inviting members.

```text
▶ cd ./master_simple
▶ terraform init
▶ terraform apply
```

Tear down:

```text
▶ terraform destroy
```

## Multi-account example

### Master invite

The example in [./master_invite](./master_invite) directory assumes two AWS accounts and sets up a GuardDuty Master in one and invites the second account to join as a GuardDuty Member account.

So as to avoid committing secrets to the revision history, environment variables need to be used to pass the Account ID and email to this example:

```text
▶ cd ./master_invite
▶ terraform init
▶ TF_VAR_member_account_id=xxxxxxxxxxxx TF_VAR_member_email=alex@somedomain.com terraform apply
```

### Member accept

Then in the member account:

```text
▶ cd ../member_accept
▶ terraform init
▶ TF_VAR_master_account_id=xxxxxxxxxxxx terraform apply
```

### Tear down

To tear both down:

```text
▶ TF_VAR_master_account_id=xxxxxxxxxxxx terraform destroy
▶ cd ../master_invite
▶ TF_VAR_member_account_id=xxxxxxxxxxxx TF_VAR_member_email=alex@somedomain.com terraform destroy
```

## Automated tests

As a proof of concept we have several versions of the automated tests.

### Bash + shunit2 + AWS CLI

To run the automated tests using the shunit2 framework:

```text
▶ make shunit2
```

### Python + PyTest + Boto3

To run the automated tests using the PyTest framework:

```text
▶ make pytest
```
