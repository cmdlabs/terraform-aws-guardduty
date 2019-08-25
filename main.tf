resource "aws_guardduty_detector" "detector" {
  enable = var.detector_enable
}

resource "aws_guardduty_ipset" "ipset" {
  count       = (var.is_guardduty_master && var.has_ipset)
  activate    = var.ipset_activate
  detector_id = aws_guardduty_detector.detector.id
  format      = var.ipset_format
  location    = "https://s3.amazonaws.com/${var.ipset_bucket}/${var.ipset_key}"
  name        = var.ipset_name
}

resource "aws_guardduty_threatintelset" "threatintelset" {
  count       = (var.is_guardduty_master && var.has_threatintelset)
  activate    = var.threatintelset_activate
  detector_id = aws_guardduty_detector.detector.id
  format      = var.threatintelset_format
  location    = "https://s3.amazonaws.com/${var.threatintelset_bucket}/${var.threatintelset_key}"
  name        = var.threatintelset_name
}
