```
##aws
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws configue

brew tap hashicorp/tap
brew install hashicorp/tap/terraform

## terraform
rm .terraform.lock.hcl
terraform init -upgrade
terraform plan -out=plan.out
terraform apply plan.out

## k8s
export KUBECONFIG=kubeconfig_k8s-cluster
kubectl -n kube-system get po

```