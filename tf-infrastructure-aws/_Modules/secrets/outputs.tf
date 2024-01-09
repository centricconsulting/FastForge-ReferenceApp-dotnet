output "arn" {
    description = "The arn of the secret"
    value       = aws_secretsmanager_secret.this.arn
}
