#!/bin/bash

# Start a local minikube cluster
minikube start

# Verify
minikube status
kubectl get nodes

# Enable ingress
minikube addons enable ingress

kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission

# Deploy
kubectl apply -f webserver.yaml

# Get ingress IP Address
ingress_ip="$(kubectl get ingress/webserver -n default -o json | jq -r '.status.loadBalancer.ingress[0].ip')"
max_loop=10
loop_count=1
while [ "${ingress_ip}" == null ]; do
	if [ "${loop_count}" -eq "${max_loop}" ]; then
		echo "Error: No ingress created."
		exit 0;
	fi
    sleep 30
	ingress_ip="$(kubectl get ingress/webserver -n default -o json | jq -r '.status.loadBalancer.ingress[0].ip')"
	loop_count=$((loop_count+1))
done
echo $ingress_ip