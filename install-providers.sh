#!/bin/bash

# helm

# Timeout duration
TIMEOUT=180
# Check interval in seconds
INTERVAL=5
# Start time
START_TIME=$(date +%s)

echo "Applying Helm provider configuration..."
kubectl apply -f provider/helm.yaml || exit 1

echo "Waiting for provider-helm to have status True where type is Healthy..."

# Loop until the condition is met or timeout
while true; do
    # Get the status of the "Healthy" condition
    STATUS=$(kubectl get provider.pkg.crossplane.io/provider-helm -o jsonpath='{.status.conditions[?(@.type=="Healthy")].status}')
    
    # If the status is True, exit the loop
    if [[ "$STATUS" == "True" ]]; then
        echo "Provider Helm is Healthy."
        break
    fi
    
    # Check if the timeout has been reached
    CURRENT_TIME=$(date +%s)
    ELAPSED_TIME=$((CURRENT_TIME - START_TIME))
    
    if (( ELAPSED_TIME >= TIMEOUT )); then
        echo "Timeout reached. Provider Helm did not become Healthy in time."
        exit 2
    fi
    
    # Sleep for the interval before checking again
    sleep $INTERVAL
done

echo "Waiting for CRDs to be established..."
kubectl wait --for=condition=established crd/providerconfigs.helm.crossplane.io --timeout=180s || exit 2

echo "Applying helm-provider-config.yaml..."
kubectl apply -f provider-config/helm.yaml || exit 3


