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
| members | TODO
| members.name | TODO
| members.email | TODO
| is_guardduty_master
| has_ipset
| has_threatintelset
| detector_enable
| ipset_activate
| ipset_format
| ipset_bucket
| ipset_key
| ipset_name
| threatintelset_activate
| threatintelset_format
| threatintelset_bucket
| threatintelset_key
| threatintelset_name
| guardduty.threatintelset.iplist | TODO

### Outputs

|Name|Description|
|------------|---------------------|
| detector_id | The ID of the GuardDuty ThreatIntelSet and the detector ID |

### Examples

TODO.
