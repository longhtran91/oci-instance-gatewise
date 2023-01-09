variable "tenancy_ocid" {
  type        = string
  description = "tenancy_ocid"
}
variable "user_ocid" {
  type        = string
  description = "user_ocid"
}
variable "fingerprint" {
  type        = string
  description = "MD5 fingerprint of the private_key"
}
variable "private_key" {
  type        = string
  description = "Private key to sign API call. Public key must be uploaded in the console."
}
variable "oci_region" {
  type        = string
  description = "Region to deploy VNC"
  validation {
    condition     = contains(["us-ashburn-1"], var.oci_region)
    error_message = "Region must be in us-ashburn-1"
  }
}
variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "Region to deploy Gatewise"
  validation {
    condition     = contains(["us-east-1", "us-east-2", "us-west-1", "us-west-2"], var.aws_region)
    error_message = "Region must be in us-east-1, us-east-2, us-west-1, or us-west-2"
  }
}
variable "compartment_id" {
  type        = string
  description = "Compartment id where to create all resources"
}
variable "vcn_display_name" {
  type        = string
  description = "Name of the VCN"
}
variable "env" {
  type        = string
  description = "Environment"
  validation {
    condition     = contains(["production", "development", "test"], var.env)
    error_message = "Environment must be production, development or test"
  }
}
variable "os_name" {
  type        = string
  description = "Name of the OS"
}
variable "os_version" {
  type        = string
  description = "Version of the OS"
}
variable "shape" {
  type        = string
  description = "Shape of the instance"
}
variable "shape_ocpus" {
  type        = number
  description = "Number of the flex CPU of the instance"
}
variable "shape_memory" {
  type        = number
  description = "Number of the flex memory in gbs of the instance"
}
variable "public_key" {
  type        = string
  description = "SSH public key"
}
variable "gatewise_instance_type" {
  type        = string
  default     = "t4g.nano"
  description = "Instance type for gatewise app"
}
variable "hostname" {
  type        = string
  description = "Domain on Route53"
}
variable "home_vpn_cidrs" {
  type        = list(string)
  description = "VCN Cidrs"
}