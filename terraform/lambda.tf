resource "aws_lambda_function" "hello" {
   function_name = var.function_name

   # The bucket name as created earlier with "aws s3api create-bucket"
   s3_bucket = var.s3_bucket
   s3_key    = var.s3_key

   # "main" is the filename within the zip file (main.js) and "handler"
   # is the name of the property under which the handler function was
   # exported in that file.
   handler = var.handler
   runtime = var.runtime

   role = aws_iam_role.lambda_exec.arn
}

 # IAM role which dictates what other AWS services the Lambda function
 # may access.
resource "aws_iam_role" "lambda_exec" {
   name = var.role_name

   assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

# The following two configurations define the API Gateway
resource "aws_api_gateway_resource" "proxy" {
   rest_api_id = aws_api_gateway_rest_api.hello.id
   parent_id   = aws_api_gateway_rest_api.hello.root_resource_id
   path_part   = "{proxy+}" # All traffic is good to go
}

# This links the API Gateway resource to the method 
# one can call to utilize it
resource "aws_api_gateway_method" "proxy" {
   rest_api_id   = aws_api_gateway_rest_api.hello.id
   resource_id   = aws_api_gateway_resource.proxy.id
   http_method   = "ANY" # Could be: GET, POST, PUT, etc...
   authorization = "NONE" # No auth token needed for this demo
}

# This links the lambda to the API Gateway
resource "aws_api_gateway_integration" "lambda" {
   rest_api_id = aws_api_gateway_rest_api.hello.id
   resource_id = aws_api_gateway_method.proxy.resource_id
   http_method = aws_api_gateway_method.proxy.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.hello.invoke_arn
}

# The following two configurations set a root path for the API Gateway
resource "aws_api_gateway_method" "proxy_root" {
   rest_api_id   = aws_api_gateway_rest_api.hello.id
   resource_id   = aws_api_gateway_rest_api.hello.root_resource_id
   http_method   = "ANY"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
   rest_api_id = aws_api_gateway_rest_api.hello.id
   resource_id = aws_api_gateway_method.proxy_root.resource_id
   http_method = aws_api_gateway_method.proxy_root.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.hello.invoke_arn
}

# This gives permission to the API Gateway to call the
# Lambda function we defined above
resource "aws_lambda_permission" "apigw" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.hello.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_api_gateway_rest_api.hello.execution_arn}/*/*"
}

# This deploys the API Gateway
resource "aws_api_gateway_deployment" "hello" {
   depends_on = [
     aws_api_gateway_integration.lambda,
     aws_api_gateway_integration.lambda_root,
   ]

   rest_api_id = aws_api_gateway_rest_api.hello.id
   stage_name  = "test"
}

