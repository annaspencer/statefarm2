resource "aws_api_gateway_rest_api" "hello" {
  name        = var.function_name
  description = var.describe_function
}

output "base_url" {
  value = aws_api_gateway_deployment.hello.invoke_url
}
