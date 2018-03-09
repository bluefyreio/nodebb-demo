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
