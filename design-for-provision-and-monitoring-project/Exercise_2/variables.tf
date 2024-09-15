variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "lambdaFunctionName" {
  type = string
  default = "helloWolrdLambda"
}

variable "lambdaOutputPath" {
  type = string
  default = "output.zip"
}