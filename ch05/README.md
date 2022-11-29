```
##aws
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws configue

brew tap hashicorp/tap
brew install hashicorp/tap/terraform

## terraform
rm -rf .terraform .terraform.lock.hcl *tfplan*
terraform init -upgrade
terraform plan -out tfplan
terraform show -json tfplan | jq > tfplan.json
terraform apply tfplan

terraform plan –out=plan.out
terraform apply plan.out --auto-approve

## k8s
export KUBECONFIG=kubeconfig_k8s-cluster
kubectl -n kube-system get po

terraform destroy –auto-approve
rm -rf .terraform .terraform.lock.hcl *.tfstate*

```