# <img src="https://bluefyre.blob.core.windows.net/images/bluefyre.logo.side.200by50.png" width="150"><br />


## NodeBB demo app for k8
A Node.js web application based on the popular [NodeBB](https://github.com/nodebb/) utilizing [Bluefyre](https://bluefyre.io)'s kubernetes native runtime application security.


## Instructions
This repo sets up the docker image for the NodeBB application v1.7.5 using MongoDB.

## Prerequisites
Refer to this [blog post](https://bluefyre.io/nodejs-appsec-kubernetes-nodebb) for prerequisites for minikube, xhyve, OSX. You can certainly run this without minikube as well.

If you're running minikube on OSX, make sure to run the following to set the right context for your docker images
```
minikube config set vm-driver virtualbox
minikube start --memory=4096
eval $(minikube docker-env)
```

## Running
1. Let's set up the nodebb namespace in your Kubernetes cluster
```
kubectl create -f namespace.yaml
```

2. Create the persistent volumes needed for Mongo. You can skip this step if you already have volumes you intend to use.
```
kubectl create -f local-volumes.yaml
kubectl get pv
```

3. Set up the Mongo service that uses the persistent volumes defined earlier
```
kubectl create -f mongo.yaml --namespace=nodebb
```

4. Signup at [Bluefyre](https://portal.bluefyre.io/signup) to obtain a free agent API key. Refer [docs](https://bluefyre.io/docs) here for how to do this. 
Once you've obtained this
```
# Replace BLUEFYRE_AGENT_ID with the API key from the Bluefyre app
kubectl create secret generic bluefyre-agent-id --from-literal=agentid=BLUEFYRE_AGENT_ID --namespace=nodebb
kubectl get secrets --namespace=nodebb
```

5. Also once you've signed up at [Bluefyre](https://portal.bluefyre.io/account3/download) to download the Node.js microagent. Place the `bluefyre-agent-node-x.x.xtgz` in the same folder as the Dockerfile

6. Now lets set up the app build
```
cd ../
docker build -t nodebb:v1 .
```

7. Lets set up a job to setup the environment
```
cd k8
kubectl create -f nodebb-setup.yaml --namespace=nodebb
```
Verify that the job ran successfully
```
kubectl get jobs
kubectl logs REPLACE_YOUR_POD_ID_HERE -f
```

8. Now lets set up the app
```
kubectl create -f nodebb.yaml --namespace=nodebb
```

9. Now in your browser, navigate to the service
```
minikube service nodebb --url
```

10. View realtime vulnerabilities in your [Bluefyre](https://portal.bluefyre.io) portal


## TODO
- update k8 setup scripts with user/pw secrets for MongoDB

## Screenshots

Here are some screenshots from NodeBB. For more updated info, refer the [NodeBB](https://github.com/nodebb/) repo

[![](http://i.imgur.com/VCoOFyqb.png)](http://i.imgur.com/VCoOFyq.png)
[![](http://i.imgur.com/FLOUuIqb.png)](http://i.imgur.com/FLOUuIq.png)
[![](http://i.imgur.com/Ud1LrfIb.png)](http://i.imgur.com/Ud1LrfI.png)
[![](http://i.imgur.com/h6yZ66sb.png)](http://i.imgur.com/h6yZ66s.png)
[![](http://i.imgur.com/o90kVPib.png)](http://i.imgur.com/o90kVPi.png)
[![](http://i.imgur.com/AaRRrU2b.png)](http://i.imgur.com/AaRRrU2.png)
[![](http://i.imgur.com/LmHtPhob.png)](http://i.imgur.com/LmHtPho.png)
[![](http://i.imgur.com/paiJPJkb.jpg)](http://i.imgur.com/paiJPJk.jpg)


## License

NodeBB is licensed under the **GNU General Public License v3 (GPL-3)** (http://www.gnu.org/copyleft/gpl.html).
