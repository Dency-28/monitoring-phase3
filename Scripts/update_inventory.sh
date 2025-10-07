#!/bin/bash
# 🔁 Automatically update inventory.ini with latest EC2 IP

# Navigate to Terraform directory (adjust if needed)
cd /mnt/c/Users/KDency/Tf-den/terraform_infra || exit 1

# Extract EC2 public IP dynamically from Terraform output
EC2_IP=$(terraform output -raw ec2_public_ip)

if [ -z "$EC2_IP" ]; then
  echo "❌ No EC2 IP found. Run Terraform apply in infra repo first."
  exit 1
fi

echo "✅ Found EC2 IP: $EC2_IP"

# Go back to monitoring repo path
cd /mnt/c/Users/KDency/monitoring-phase3 || exit 1

# Write inventory.ini dynamically
cat > inventory.ini <<EOF
[all]
ec2-instance ansible_host=$EC2_IP ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/deployer.pem

[all:vars]
ansible_python_interpreter=/usr/bin/python3
EOF

echo "✅ Updated inventory.ini with EC2 IP: $EC2_IP"
