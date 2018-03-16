# set up the namespace
kubectl create -f namespace.yaml

#set up local volumes
kubectl create -f local-volumes.yaml
kubectl get pv

# Replace BLUEFYRE_AGENT_ID with the API key from the Bluefyre app
kubectl create secret generic bluefyre-agent-id --from-literal=agentid=BLUEFYRE_AGENT_ID --namespace=nodebb

# set your default admin username and password
kubectl create secret generic nodebbadminusername --from-literal=nodebbadminusername=admin --namespace=nodebb
kubectl create secret generic nodebbadminpassword --from-literal=nodebbadminpassword=REPLACEME --namespace=nodebb

kubectl get secrets --namespace=nodebb

# set up the mongo service, pvclaim, deployment
kubectl create -f mongo.yaml --namespace=nodebb

# run the setup job
# kubectl create -f nodebb-setup.yaml --namespace=nodebb

# run the nodebb service
kubectl create -f nodebb.yaml --namespace=nodebb

# setup the ingress controller
kubectl create -f nodebb-ingress.yaml -n nodebb
kubectl create -f nodebb-ingress-sticky.yaml -n nodebb


# clear everything
kubectl delete service,deployment,replicationcontroller,job,persistentvolumeclaim,secret --all --namespace=nodebb

# clear ingress controller
kubectl delete ingress nodebb-ingress

# clear just infrastructure without secrets
kubectl delete service,deployment,replicationcontroller,job,persistentvolumeclaim --all --namespace=nodebb

# clear just the app
kubectl delete service,deployment -l name=web --namespace=nodebb

# clear the setup job
kubectl delete job -l app=nodebb-init --namespace=nodebb
