#Module      : LABEL
#Description : Terraform label module variables
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = []
  description = "Label order, e.g. `name`,`application`."
}

variable "repository" {
  type        = string
  default     = "https://github.com/clouddrove/terraform-aws-alb-multi-targetgroup"
  description = "Terraform current module repo"
}

variable "attributes" {
  type        = list(any)
  default     = []
  description = "Additional attributes (e.g. `1`)."
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `organization`, `environment`, `name` and `attributes`."
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)."
}

variable "managedby" {
  type        = string
  default     = "anmol@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove' or 'AnmolNagpal'."
}

# Module      : ALB
# Description : Terraform ALB module variables.

variable "instance_count" {
  type        = number
  default     = 0
  description = "The count of instances."
}

variable "internal" {
  type        = string
  default     = ""
  description = "If true, the LB will be internal."
}

variable "load_balancer_type" {
  type        = string
  default     = ""
  description = "The type of load balancer to create. Possible values are application or network. The default value is application."
}

variable "drop_invalid_header_fields" {
  type        = bool
  default     = false
  description = "Indicates whether HTTP headers with header fields that are not valid are removed by the load balancer (true) or routed to targets (false). The default is false. Elastic Load Balancing requires that message header names contain only alphanumeric characters and hyphens. Only valid for Load Balancers of type application."
}

variable "subnet_mapping" {
  default     = []
  type        = list(map(string))
  description = "A list of subnet mapping blocks describing subnets to attach to network load balancer"
}

variable "https_listeners" {
  description = "A list of maps describing the HTTPS listeners for this ALB. Required key/values: port, certificate_arn. Optional key/values: ssl_policy (defaults to ELBSecurityPolicy-2016-08), target_group_index (defaults to 0)"
  type        = list(map(string))
  default     = []
}

variable "http_tcp_listeners" {
  description = "A list of maps describing the HTTP listeners for this ALB. Required key/values: port, protocol. Optional key/values: target_group_index (defaults to 0)"
  type        = list(map(string))
  default     = []
}

variable "target_groups" {
  description = "A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend_protocol, backend_port. Optional key/values are in the target_groups_defaults variable."
  type        = any
  default     = []
}

variable "security_groups" {
  type        = list(any)
  default     = []
  description = "A list of security group IDs to assign to the LB. Only valid for Load Balancers of type application."
}

variable "subnets" {
  type        = list(any)
  default     = []
  description = "A list of subnet IDs to attach to the LB. Subnets cannot be updated for Load Balancers of type network. Changing this value will for load balancers of type network will force a recreation of the resource."
}

variable "enable_deletion_protection" {
  type        = bool
  default     = false
  description = "If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false."
}

variable "subnet_id" {
  type        = string
  default     = ""
  description = "The id of the subnet of which to attach to the load balancer. You can specify only one subnet per Availability Zone."
}

variable "allocation_id" {
  type        = string
  default     = ""
  description = "The allocation ID of the Elastic IP address."
}

variable "https_port" {
  type        = number
  default     = 443
  description = "The port on which the load balancer is listening. like 80 or 443."
}

variable "https_protocol" {
  type        = string
  default     = "HTTPS"
  description = "The protocol for connections from clients to the load balancer. Valid values are TCP, HTTP and HTTPS. Defaults to HTTP."
}

variable "http_protocol" {
  type        = string
  default     = "HTTP"
  description = "The protocol for connections from clients to the load balancer. Valid values are TCP, HTTP and HTTPS. Defaults to HTTP."
}

variable "http_ports" {
  type        = list(string)
  default     = []
  description = "The port on which the load balancer is listening. like 80 or 443."
}

variable "https_enabled" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable HTTPS listener."
}

variable "http_enabled" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable HTTP listener."
}

variable "listener_type" {
  type        = string
  default     = "forward"
  description = "The type of routing action. Valid values are forward, redirect, fixed-response, authenticate-cognito and authenticate-oidc."
}

variable "listener_ssl_policy" {
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
  description = "The security policy if using HTTPS externally on the load balancer. [See](https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html)."
}

variable "listener_certificate_arn" {
  type        = string
  default     = ""
  description = "The ARN of the SSL server certificate. Exactly one certificate is required if the col is HTTPS."
}

variable "target_group_port" {
  type        = list(any)
  default     = []
  description = "The port on which targets receive traffic, unless overridden when registering a specific target."
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "The identifier of the VPC in which to create the target group."
}

variable "target_id" {
  type        = list(any)
  description = "The ID of the target. This is the Instance ID for an instance, or the container ID for an ECS container. If the target type is ip, specify an IP address."
}

variable "idle_timeout" {
  type        = number
  default     = 60
  description = "The time in seconds that the connection is allowed to be idle."
}

variable "enable_cross_zone_load_balancing" {
  type        = bool
  default     = false
  description = "Indicates whether cross zone load balancing should be enabled in application load balancers."
}

variable "enable_http2" {
  type        = bool
  default     = true
  description = "Indicates whether HTTP/2 is enabled in application load balancers."
}

variable "ip_address_type" {
  type        = string
  default     = "ipv4"
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack."
}

variable "log_bucket_name" {
  type        = string
  default     = ""
  description = "S3 bucket (externally created) for storing load balancer access logs. Required if logging_enabled is true."
}

variable "load_balancer_create_timeout" {
  type        = string
  default     = "10m"
  description = "Timeout value when creating the ALB."
}

variable "load_balancer_delete_timeout" {
  type        = string
  default     = "10m"
  description = "Timeout value when deleting the ALB."
}

variable "load_balancer_update_timeout" {
  type        = string
  default     = "10m"
  description = "Timeout value when updating the ALB."
}

variable "access_logs" {
  type        = bool
  default     = false
  description = "Access logs Enable or Disable."
}

variable "http_listener_type" {
  type        = string
  default     = "forward"
  description = "The type of routing action. Valid values are forward, redirect, fixed-response, authenticate-cognito and authenticate-oidc."
}

variable "status_code" {
  type        = string
  default     = "HTTP_301"
  description = " The HTTP redirect code. The redirect is either permanent (HTTP_301) or temporary (HTTP_302)."
}

variable "enable" {
  type        = bool
  default     = false
  description = "If true, create alb."
}

variable "alb_enable" {
  type        = bool
  default     = true
  description = "If true, create alb."
}

variable "enable_target_group" {
  type        = bool
  default     = true
  description = "If true, create alb."
}
