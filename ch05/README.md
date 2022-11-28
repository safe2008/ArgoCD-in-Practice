```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws configue

brew tap hashicorp/tap
brew install hashicorp/tap/terraform

terraform init
terraform plan –out=plan.out -var=zone_id=<your-zone-id>

```