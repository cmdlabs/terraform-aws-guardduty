resource "aws_s3_bucket" "bucket" {
  acl = "private"
}

module "guardduty" {
  source = "../"
  is_guardduty_master = true
  has_ipset = true
  has_threatintelset = true
  detector_enable = true

  ipset_activate = true
  ipset_format = "TXT"
  ipset_bucket = aws_s3_bucket.bucket.id
  ipset_key = "ipset.txt"
  ipset_name = "MyIPSet"
  ipset_iplist = [
    "1.1.1.1",
    "2.2.2.2",
  ]

  threatintelset_activate = true
  threatintelset_format = "TXT"
  threatintelset_bucket = aws_s3_bucket.bucket.id
  threatintelset_key = "threatintelset.txt"
  threatintelset_name = "MyThreatIntelSet"
  threatintelset_iplist = [
    "3.3.3.3",
    "4.4.4.4",
  ]
}
