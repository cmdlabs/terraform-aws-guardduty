module "guardduty" {
  source = "../../"

  detector_enable = true
  is_guardduty_master = true
  has_ipset = true
  has_threatintelset = true

  ipset_activate = true
  ipset_format = "TXT"
  ipset_iplist = [
    "1.1.1.1",
    "2.2.2.2",
  ]

  threatintelset_activate = true
  threatintelset_format = "TXT"
  threatintelset_iplist = [
    "3.3.3.3",
    "4.4.4.4",
  ]
}
