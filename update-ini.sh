#!/bin/bash

# Retrieve EC2 Data & Remove Old Inventory File
aws ec2 describe-instances \
    --region us-west-2 \
    --filters "Name=tag:Name,Values=k8s-node*" "Name=instance-state-name,Values=running" \
    --query "Reservations[*].Instances[*].{Name:Tags[?Key=='Name']|[0].Value, PublicIpAddress:PublicIpAddress}" \
    --output json | jq -r '[.[][]] | sort_by(.Name)' > nodes.json

rm -f inventories/project.ini

# Create [all] Group
echo -e "[all]" >> inventories/project.ini

for i in $(jq -r '.[].Name' nodes.json); do
    IP=$(jq -r --arg i "$i" '.[] | select(.Name == $i) | .PublicIpAddress' nodes.json)
    LINE="$i ansible_host=$IP ansible_user=ubuntu ansible_ssh_private_key_file=/Users/alexanderkalaj/.ssh/sre-key ansible_python_interpreter=/usr/bin/python3 ansible_ssh_common_args='-o StrictHostKeyChecking=no'"
    echo $LINE >> inventories/project.ini
done

echo -e "\n" >> inventories/project.ini

# Create [kube_masters] Group
echo "[kube_masters]" >> inventories/project.ini

IP=$(jq -r --arg i "$i" '.[] | select(.Name == "k8s-node-1") | .PublicIpAddress' nodes.json)
LINE="k8s-node-1 ansible_host=$IP ansible_user=ubuntu ansible_ssh_private_key_file=/Users/alexanderkalaj/.ssh/sre-key ansible_python_interpreter=/usr/bin/python3 ansible_ssh_common_args='-o StrictHostKeyChecking=no'"
echo $LINE >> inventories/project.ini

echo -e "\n" >> inventories/project.ini

# Create [kube_workers] Group
echo "[kube_workers]" >> inventories/project.ini

for i in $(jq -r '.[].Name' nodes.json | grep -v k8s-node-1); do
    IP=$(jq -r --arg i "$i" '.[] | select(.Name == $i) | .PublicIpAddress' nodes.json)
    LINE="$i ansible_host=$IP ansible_user=ubuntu ansible_ssh_private_key_file=/Users/alexanderkalaj/.ssh/sre-key ansible_python_interpreter=/usr/bin/python3 ansible_ssh_common_args='-o StrictHostKeyChecking=no'"
    echo $LINE >> inventories/project.ini
done