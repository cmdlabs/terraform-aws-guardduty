output "detector_id" {
  description = "The ID of the GuardDuty detector"
  value       = aws_guardduty_detector.detector.id
}

output "account_id" {
  description = "The AWS account ID of the GuardDuty detector"
  value       = aws_guardduty_detector.detector.account_id
}
