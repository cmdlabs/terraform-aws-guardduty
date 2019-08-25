variable "is_guardduty_master" {
  type        = bool
  description = "Whether the account is a master account"
  default     = false
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

variable "detector_enable" {
  type        = bool
  description = "Enable monitoring and feedback reporting"
  default     = true
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

variable "ipset_bucket" {
  type        = string
  description = "The preconfigured S3 bucket which hosts the whitelist file"
  default     = "TXT"
}

variable "ipset_key" {
  type        = string
  description = "The filename which gets created in S3 and stores whitelisted IP addresses"
  default     = "TXT"
}

variable "ipset_name" {
  type        = string
  description = "The friendly name to identify the IPSet"
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

variable "threatintelset_bucket" {
  type        = string
  description = "The preconfigured S3 bucket which hosts the whitelist file"
}

variable "threatintelset_key" {
  type        = string
  description = "The filename which gets created in S3 and stores whitelisted IP addresses"
}

variable "threatintelset_name" {
  type        = string
  description = "The friendly name to identify the ThreatIntelSet"
}
