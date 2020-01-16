variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket to use"
  default     = ""
}

variable "is_guardduty_master" {
  type        = bool
  description = "Whether the account is a master account"
  default     = false
}

variable "is_guardduty_member" {
  type        = bool
  description = "Whether the account is a member account"
  default     = false
}

variable "detector_enable" {
  type        = bool
  description = "Enable monitoring and feedback reporting"
  default     = true
}

variable "has_ipset" {
  type        = bool
  description = "Whether to include IPSet"
  default     = false
}

variable "has_threatintelset" {
  type        = bool
  description = "Whether to include ThreatIntelSet"
  default     = false
}

variable "ipset_activate" {
  type        = bool
  description = "Specifies whether GuardDuty is to start using the uploaded IPSet"
  default     = true
}

variable "ipset_format" {
  type        = string
  description = "The format of the file that contains the IPSet"
  default     = "TXT"
}

variable "ipset_iplist" {
  type        = list
  description = "IPSet list of trusted IP addresses"
  default     = []
}

variable "threatintelset_activate" {
  type        = bool
  description = "Specifies whether GuardDuty is to start using the uploaded ThreatIntelSet"
  default     = true
}

variable "threatintelset_format" {
  type        = string
  description = "The format of the file that contains the ThreatIntelSet"
  default     = "TXT"
}

variable "threatintelset_iplist" {
  type        = list
  description = "ThreatIntelSet list of known malicious IP addresses"
  default     = []
}

variable "master_account_id" {
  type        = string
  description = "Account ID for Guard Duty Master. Required if is_guardduty_member"
  default     = ""
}

variable "member_list" {
  type = list(object({
    account_id   = string
    member_email = string
    invite       = bool
  }))
  description = "The list of member accounts to be added. Each member list need to have values of account_id, member_email and invite boolean"
  default     = []
}
