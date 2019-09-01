<!-- vim: set ft=markdown: -->
# terraform-aws-guardduty

## Overview

Amazon GuardDuty is a continuous security monitoring service that analyzes and processes the following data sources: VPC Flow Logs, AWS CloudTrail event logs, and DNS logs. It uses threat intelligence feeds, such as lists of malicious IPs and domains, and machine learning to identify unexpected and potentially unauthorized and malicious activity within your AWS environment.

This repo contains Terraform modules for configuring AWS GuardDuty and managing IPSets and ThreadSets used by GuardDuty.

__Note__: GuardDuty only needs to be run in a single auditing account. This account will contain the S3 bucket which will have the IPSet and ThreatIntelSet lists uploaded to.

Terraform >= 0.12 is required for this module.

## AWS GuardDuty - Overview Diagram

![GuardDuty|medium](docs/guardduty.png)

## AWS GuardDuty Terraform

### Resources docs

AWS GuardDuty automation includes use of the following core Terraform resources:

- [`aws_guardduty_detector`](https://www.terraform.io/docs/providers/aws/r/guardduty_detector.html) - Single GuardDuty Detector object
- [`aws_guardduty_ipset`](https://www.terraform.io/docs/providers/aws/r/guardduty_ipset.html) - IPSet is a list of trusted IP addresses
- [`aws_guardduty_threatintelset`](https://www.terraform.io/docs/providers/aws/r/guardduty_threatintelset.html) - ThreatIntelSet is a list of known malicious IP addresses

### Inputs

The below outlines the current parameters and defaults.

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
|is_guardduty_master|Whether the account is a master account|bool|false|No|
|is_guardduty_member|Whether the account is a member account|bool|false|No|
|detector_enable|Enable monitoring and feedback reporting|bool|true|No|
|has_ipset|Whether to include IPSet|bool|false|No|
|has_threatintelset|Whether to include ThreatIntelSet|bool|false|No|
|ipset_activate|Specifies whether GuardDuty is to start using the uploaded IPSet|bool|true|No|
|ipset_format|The format of the file that contains the IPSet|string|TXT|No|
|ipset_iplist|TODO|list|[]|No|
|threatintelset_activate|Specifies whether GuardDuty is to start using the uploaded ThreatIntelSet|bool|true|No|
|threatintelset_format|The format of the file that contains the ThreatIntelSet|string|TXT|No|
|threatintelset_iplist|TODO|list|[]|No|
|master_account_id|Account ID for Guard Duty Master. Required if is_guardduty_member|string||Yes|
|member_list|The list of member accounts to be added. Each member list need to have values of account_id, member_email and invite boolean|object|[]|No|


### Outputs

|Name|Description|
|------------|---------------------|
| detector_id | The ID of the GuardDuty ThreatIntelSet and the detector ID |

### Examples

TODO.
