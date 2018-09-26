This site is a good resource for bringing up k8's after kubeadm is [installed](https://kubernetes.io/docs/setup/independent/install-kubeadm/).

If there is an issue with a bunch of docker containers stuck even after a `kubeadm reset` you can run
```
# this is like break the glass and pull the lever!
rm -Rf /var/lib/docker
```

To initialize the cluster master I start with this command (some added for flannel):
```
kubeadm init --pod-network-cidr=10.244.0.0/16
```

Then:
```
# if running as root do:
export KUBECONFIG=/etc/kubernetes/admin.conf

# else
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Next start the pod networking (I am using flannel here):
```
sysctl net.bridge.bridge-nf-call-iptables=1
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.10.0/Documentation/kube-flannel.yml
```
Can look at your cluster:
```
kubectl get all --all-namespaces
```

Install Helm:
```
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
```

Once Helm installed:
```
helm init
```

Setup Tiller's permissions:
```
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
```

You can take a look at your node and pods with:
```
kubectl get node
kubectl get pods --all-namespaces
```