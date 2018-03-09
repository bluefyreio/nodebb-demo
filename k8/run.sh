# set up the namespace
kubectl create -f namespace.yaml

#set up local volumes
kubectl create -f local-volumes.yaml
kubectl get pv

# Replace BLUEFYRE_AGENT_ID with the API key from the Bluefyre app
kubectl create secret generic bluefyre-agent-id --from-literal=agentid=BLUEFYRE_AGENT_ID --namespace=nodebb

kubectl get secrets --namespace=nodebb

# set up the mongo service, pvclaim, deployment
kubectl create -f mongo.yaml --namespace=nodebb


# run the setup job
kubectl create -f nodebb-setup.yaml --namespace=nodebb

# set up the nodebb service
kubectl create -f nodebb.yaml --namespace=nodebb



# clear everything
kubectl delete service,deployment,replicationcontroller -l app=nodebb --namespace=nodebb

# clear just the app
kubectl delete service,deployment -l name=web --namespace=nodebb