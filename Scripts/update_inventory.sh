#!/bin/bash
# Navigate to Terraform infra folder (GitHub Actions runner)
cd Tf-den/terraform_infra || { echo "Terraform path not found"; exit 1; }

# Get EC2 IP from Terraform output
EC2_IP=$(./terraform output -raw ec2_public_ip)

if [ -z "$EC2_IP" ]; then
  echo "❌ No EC2 IP found. Run 'terraform apply' first."
  exit 1
fi

echo "✅ Found EC2 IP: $EC2_IP"

# Ensure SSH key permissions are correct
chmod 600 ~/.ssh/deployer.pem
echo "✅ SSH key permissions set"

# Update Ansible inventory
cat > inventory.ini <<EOF
[all]
ec2-instance ansible_host=$EC2_IP ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/deployer.pem

[all:vars]
ansible_python_interpreter=/usr/bin/python3
EOF

echo "✅ Updated inventory.ini with IP $EC2_IP"
