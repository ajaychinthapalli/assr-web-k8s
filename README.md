[![Kubernetes Web](https://github.com/ajaychinthapalli/k8s-web/actions/workflows/main.yaml/badge.svg)](https://github.com/ajaychinthapalli/k8s-web/actions/workflows/main.yaml)
# k8s-web
## Steps for setup
### Required packages
- minikube
    - `brew install minikube` (installs kubectl[kubernetes-cli], docker-runtime and docker-daemon as well)
- jq (Command-line JSON processor)
    - `brew install jq`

### Starting the application
```text
@ajaychinthapalli ➜ /workspaces/k8s-web (main) $ chmod +x setup.sh
@ajaychinthapalli ➜ /workspaces/k8s-web (main ✗) $ ./setup.sh => outputs the ingress ip-address
```
```text
@ajaychinthapalli ➜ /workspaces/k8s-web (main ✗) $ ./setup.sh
😄  minikube v1.28.0 on Ubuntu 20.04 (docker/amd64)
✨  Automatically selected the docker driver. Other choices: ssh, none
📌  Using Docker driver with root privileges
👍  Starting control plane node minikube in cluster minikube
🚜  Pulling base image ...
💾  Downloading Kubernetes v1.25.3 preload ...
    > preloaded-images-k8s-v18-v1...:  385.44 MiB / 385.44 MiB  100.00% 175.68 
    > gcr.io/k8s-minikube/kicbase:  386.27 MiB / 386.27 MiB  100.00% 46.51 MiB 
    > gcr.io/k8s-minikube/kicbase:  0 B [_______________________] ?% ? p/s 7.4s
🔥  Creating docker container (CPUs=2, Memory=2200MB) ...
🐳  Preparing Kubernetes v1.25.3 on Docker 20.10.20 ...
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🔎  Verifying Kubernetes components...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Enabled addons: storage-provisioner, default-storageclass
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured

NAME       STATUS     ROLES           AGE   VERSION
minikube   NotReady   control-plane   13s   v1.25.3
💡  ingress is an addon maintained by Kubernetes. For any concerns contact minikube on GitHub.
You can view the list of minikube maintainers at: https://github.com/kubernetes/minikube/blob/master/OWNERS
    ▪ Using image k8s.gcr.io/ingress-nginx/controller:v1.2.1
    ▪ Using image k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1
    ▪ Using image k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1
🔎  Verifying ingress addon...
🌟  The 'ingress' addon is enabled
validatingwebhookconfiguration.admissionregistration.k8s.io "ingress-nginx-admission" deleted
deployment.apps/webserver created
service/webserver created
ingress.networking.k8s.io/webserver created
192.168.49.2
```

### Updating the application
On `workflow dispatch` (Event trigger workflow), GitHub workflow updates the image in docker hub.  
To update the running pods, run:
```text
@ajaychinthapalli ➜ /workspaces/k8s-web (main ✗) $ ./deploy.sh
deployment.apps/webserver restarted
Waiting for deployment spec update to be observed...
Waiting for deployment spec update to be observed...
Waiting for deployment "webserver" rollout to finish: 0 out of 3 new replicas have been updated...
Waiting for deployment "webserver" rollout to finish: 1 out of 3 new replicas have been updated...
Waiting for deployment "webserver" rollout to finish: 1 out of 3 new replicas have been updated...
Waiting for deployment "webserver" rollout to finish: 1 out of 3 new replicas have been updated...
Waiting for deployment "webserver" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "webserver" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "webserver" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "webserver" rollout to finish: 1 old replicas are pending termination...
Waiting for deployment "webserver" rollout to finish: 1 old replicas are pending termination...
deployment "webserver" successfully rolled out
```

## Application architecture/strategy
- The application is a basic flask-app that runs on a local minikube cluster
- It runs as a docker container and being a flask app listens on port 5000 by default
- It exposes 2 endpoints:
    - [GET] / => "Hello World!"
    - [GET] /healthcheck => "OK"
- It is dockerized and the image is available in docker hub:
    - docker pull `achin16/flask-app`
- The build process is automated using GitHub workflow.
- The container runs inside a pod, the smallest computing unit in Kubernetes
- To maintain high availability, we maintain 3 replicas of the pod which are managed by a **Deployment**
- The **Ingress** resource does the load balancing
- **Service** component is responsible for providing a single entrypoint for the pods
- The container also have liveness and readiness probes configured to ensure that containers are healthy and ready before serving traffic.

## Connecting to application
Launch the ingress ip-address received as output of running setup.sh script in a browser

