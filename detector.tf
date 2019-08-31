resource "aws_guardduty_detector" "detector" {
  enable = var.detector_enable
}
