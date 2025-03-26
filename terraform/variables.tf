variable "app_name" {
  description = "Application name prefix for resources"
  default     = "myapp"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, prod..)"
  default     = "dev"
  type        = string
}

variable "region" {
  description = "AWS region"
  default     = "ap-southeast-1" # Singapore
  type        = string
}

variable "ecs_cpu" {
  description = "CPU units for ECS Fargate task (256 = 0.25 vCPU)"
  default     = "256" # Minimum for Fargate, free-tier eligible
  type        = string
}

variable "ecs_memory" {
  description = "Memory for ECS Fargate task in MiB"
  default     = "512" # Minimum for Fargate with 256 CPU, free-tier eligible
  type        = string
}

variable "ecs_desired_count" {
  description = "Number of ECS tasks to run"
  default     = 1 # Single task to minimize cost
  type        = number
}

variable "db_instance_class" {
  description = "RDS instance class"
  default     = "db.t3.micro" # Free-tier eligible
  type        = string
}

variable "db_allocated_storage" {
  description = "RDS storage in GB"
  default     = 20 # Minimum for free tier
  type        = number
}

variable "container_image" {
  description = "Docker image for ECS"
  default     = "amazon/amazon-ecs-sample" # Free sample image
  type        = string
}

variable "db_password" {
  description = "Database password"
  default     = "learnTerraform123!" # Simple default for learning (override in production)
  type        = string
  sensitive   = true
}

variable "webapp_url" {
  description = "URL for the web application"
  default     = "http://localhost:3000" # Default for local development
  type        = string
}

variable "nextauth_url" {
  description = "URL for the NextAuth.js API"
  default     = "http://localhost:3000" # Default for local development
  type        = string
}

variable "encryption_key" {
  description = "Encryption key for sensitive data"
  default     = "supersecret"
  type        = string
  sensitive   = true
}

variable "nextauth_secret" {
  description = "NextAuth secret for JWT"
  default     = "supersecret"
  type        = string
  sensitive   = true
}

variable "cron_secret" {
  description = "Secret for cron job"
  default     = "supersecret"
  type        = string
  sensitive   = true
}
