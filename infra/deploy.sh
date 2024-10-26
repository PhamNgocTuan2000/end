echo "please provider terraform workspace"
read tfwf
terraform workspace new $tfwf
terraform workspace select $tfwf
current_tfwsp=$(terraform workspace show)
terraform init -backend-config=dev.conf
terraform plan -var-file=envs/${current_tfwsp}.tfvars
terraform apply -var-file=envs/${current_tfwsp}.tfvars