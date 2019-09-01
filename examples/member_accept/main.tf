variable "master_account_id" {}

module "guardduty" {
  source = "../../"
  detector_enable = true
  is_guardduty_member = true
  master_account_id = var.master_account_id
}
