resource "aws_guardduty_detector" "detector" {
  enable = var.detector_enable
}

resource "aws_s3_bucket_object" "ipset" {
  count   = (var.is_guardduty_master && var.has_ipset ? 1 : 0)
  acl     = "public-read" # TODO Check
  content = templatefile("${path.module}/templates/ipset.txt.tpl",
              {ipset_iplist = var.ipset_iplist})
  bucket  = var.ipset_bucket
  key     = var.ipset_key
}

resource "aws_guardduty_ipset" "ipset" {
  count       = (var.is_guardduty_master && var.has_ipset ? 1 : 0)
  activate    = var.ipset_activate
  detector_id = aws_guardduty_detector.detector.id
  format      = var.ipset_format
  location    = "https://s3.amazonaws.com/${var.ipset_bucket}/${var.ipset_key}"
  name        = var.ipset_name
}

resource "aws_s3_bucket_object" "threatintelset" {
  count   = (var.is_guardduty_master && var.has_threatintelset ? 1 : 0)
  acl     = "public-read" # TODO Check
  content = templatefile("${path.module}/templates/threatintelset.txt.tpl",
              {threatintelset_iplist = var.threatintelset_iplist})
  bucket  = var.threatintelset_bucket
  key     = var.threatintelset_key
}

resource "aws_guardduty_threatintelset" "threatintelset" {
  count       = (var.is_guardduty_master && var.has_threatintelset ? 1 : 0)
  activate    = var.threatintelset_activate
  detector_id = aws_guardduty_detector.detector.id
  format      = var.threatintelset_format
  location    = "https://s3.amazonaws.com/${var.threatintelset_bucket}/${var.threatintelset_key}"
  name        = var.threatintelset_name
}
