# TODO: Define the output variable for the lambda function.
output "lambda_function_output" {
  value = "aws_lambda_function.helloWolrdLambda.arn"
}