variable "rsg_name" {
  type = string
  default = "test"
}

variable "location" {
  description = "Location name"
  default     = "East US"
}

variable "data_factName" {
  type = string
  description = "data factory name"
  default = "dataFactorykaotest"
}

variable "factory_pipeline_name" {
  type = string
  description = "Data factory pipeline name"
  default = "factoryPipelinetest"
}

variable "factory_trigger_schedule_name" {
  type = string
  description = "data factory trigger schedule"
  default = "factorySchedulertest"
}

