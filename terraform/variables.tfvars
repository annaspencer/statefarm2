function_name = "hello-world"
describe_function = "Describe me."

# This must be a unique name
# The AWS_DEFAULT_ROLE in the .gitlab-ci.yml must match the role here.
role_name = "demo_terraform_2020"

# This must be a unique name
# The AWS_S3_ZIP_FILE in the .gitlab-ci.yml must match the role here.
s3_key = "v1.0.0/hello-world.zip"

################# DO NOT CHANGE ANY OF THE VARIABLES BELOW THIS LINE #################

region = "us-west-2"

handler = "main.handler"

runtime = "nodejs10.x"

s3_bucket = "2020-terraform-demo"


