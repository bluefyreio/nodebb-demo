# Configure default group
    az group create -n 'sandbox02' -l 'eastus'
    az configure --defaults group='sandbox02'

# set up the Azure storage class - we can skip this
# az storage account create --resource-group MC_sandbox02_nodebbcluster01_eastus --name nodebbcluster01storage --location eastus --sku Standard_LRS    

# Azure Container registry
    # set up azure container registry
    az acr create --name sandbox02registry --sku Basic

    # login to the container reg
    az acr login --name sandbox02registry

    # get the loginserver
    az acr list --query "[].{acrLoginServer:loginServer}" --output table

    # build the image
    cd ../
    docker build -t sandbox02registry.azurecr.io/nodebb:v1 .
    
    # push to the registry
    docker push sandbox02registry.azurecr.io/nodebb:v1

    # list all the images
    az acr repository list -n sandbox02registry

    az acr repository show-tags --name sandbox02registry --repository nodebb

# link AKS with ACS, give role assignment
CLIENT_ID=$(az aks show --name nodebbcluster01 --query "servicePrincipalProfile.clientId" --output tsv)
ACR_ID=$(az acr show --name sandbox02registry --query "id" --output tsv)

# remove default group before you do az role assignment
az configure defaults --defaults group=''
az role assignment create --assignee $CLIENT_ID --role Reader --scope $ACR_ID

# set up the namespace
kubectl create -f namespace.yaml

#set up storage account
# kubectl create -f azure-storage.yaml

# secrets

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


# get current status
kubectl get svc,deployment,rc,job,pvc,pv,secret,po  -w

# get the loadbalanced ip
kubectl get svc -n kube-system -l app=nginx-ingress -l component=controller


# clear everything
kubectl delete svc,deployment,rc,job,pvc,pv,secret,po --all --namespace=nodebb

# clear ingress controller
kubectl delete ingress nodebb-ingress

# clear just infrastructure without secrets
kubectl delete svc,deployment,rc,job,pv,pvc --all --namespace=nodebb

# clear just the app
kubectl delete svc,deployment -l name=web --namespace=nodebb

# clear the setup job
kubectl delete job -l app=nodebb-init --namespace=nodebb



# clear mongo claim
kubectl delete service,pvc,rc -l name=mongo
kubectl delete pvc -l name="mongo-pv-claim"

