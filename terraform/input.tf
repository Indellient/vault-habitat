////////////////////////////////
// AWS Connection
variable "aws_profile" {
  type        = "string"
  default     = "default"
  description = "AWS Profile used to deploy application and components found in ~/.aws/credentials file"
}

variable "aws_region" {
  type        = "string"
  default     = "us-east-1"
  description = "AWS Region to deploy application and components"
}

variable "aws_key_name" {
  type        = "string"
  description = "The name of the EC2 Key pair as seen in the AWS console."
  # Keep default blank because this should always be custom
}

variable "aws_key_pair_file" {
  type        = "string"
  description = "The key pair file corresponding to aws_key_name"
  # Keep default blank because this should always be custom
}

////////////////////////////////
// Network Setup
variable "vpc_id" {
  type        = "string"
  description = "VPC to deploy application and components into"
  # Keep default blank because this should always be custom
}

variable "subnet_id" {
  type        = "string"
  description = "Subnet to deploy application and components"
  # Keep default blank because this should always be custom
}

////////////////////////////////
// Instance Settings
variable "instance_ami" {
  type        = "string"
  description = "AMI to use for instances"
  default     = "ami-4789af38" # centOS 7
}

variable "instance_type" {
  type        = "string"
  description = "The EC2 instance type for the instances."
  default     = "t2.medium"
}

variable "instance_user" {
  type        = "string"
  description = "The user used to SSH to the AMI instance during provisioning; depends on AMI"
  default     = "centos" # default for centOS AMI
}

////////////////////////////////
// Habitat
variable "habitat_depot_url" {
  type        = "string"
  description = "The depot that holds the habitat packages."
  default     = "https://bldr.habitat.sh"
}

variable "habitat_origin" {
  type        = "string"
  description = "The origin to load packages from"
  # Keep default blank because this should always be custom
}

variable "habitat_auth_token" {
  type        = "string"
  description = "Builder auth token for habitat_origin"
  # Keep default blank because this should always be custom
}

variable "habitat_ring_key_file" {
  type        = "string"
  description = "Location of Habitat Ring Key on disk"
  # Keep default blank because this should always be custom
}

////////////////////////////////
// Vault Habitat
variable "vault_channel" {
  type        = "string"
  description = "The channel used when loading the vault package"
  default     = "stable"
}

variable "vault_strategy" {
  type        = "string"
  description = "The strategy used when loading the vault package"
  default     = "at-once"
}

variable "vault_topology" {
  type        = "string"
  description = "The topology used when loading the vault package"
  default     = "leader"
}

////////////////////////////////
// Consul Habitat

variable "consul_channel" {
  type        = "string"
  description = "The channel used when loading the consul package"
  default     = "stable"
}

variable "consul_strategy" {
  type        = "string"
  description = "The strategy used when loading the consul package"
  default     = "at-once"
}

variable "consul_topology" {
  type        = "string"
  description = "The topology used when loading the consul package"
  default     = "leader"
}

////////////////////////////////
// Tags
variable "tag_customer" {
  type        = "string"
  description = "X-Customer: A tag for identifying resources associated with a customer."
  default     = "hashicorp"
}

variable "tag_project" {
  type        = "string"
  description = "X-Project: A tag for identifying resources associated with a project."
  default     = "demo"
}

variable "tag_prefix" {
  type        = "string"
  description = "This tag is used for the leading section of the Name tag as seen in EC2 console (i.e. aws)"
  # Keep default blank because this should always be custom
}

variable "tag_environment" {
  type        = "string"
  description = "This tag is used for the environment section of the Name tag as seen in EC2 console (i.e. dev). Can potentially be set to terraform.workspace"
  # Keep default blank because this should always be custom
}

variable "tag_dept" {
  type        = "string"
  description = "X-Dept: A tag for identifying resources associated with your department."
  default     = "DevOps"
}

variable "tag_contact" {
  type        = "string"
  description = "X-Contact: A tag for identifying resources associated with your contact info. Use the form: my_name (myname@example.com)"
  default     = "damithk@indellient.com"
}

variable "tag_application_vault" {
  type        = "string"
  description = "X-Application: A tag for identifying resources associated with your application."
  default     = "Vault"
}

variable "tag_application_consul" {
  type        = "string"
  description = "X-Application: A tag for identifying resources associated with your application."
  default     = "Consul"
}

variable "tag_ttl" {
  type        = "string"
  description = "X-TTL: A tag for identifying time-to-live. Set for the number of hours until an instance is automatically destroyed. Set to 0 for never kill."
  default = 3600
}
