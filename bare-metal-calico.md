Initalizing a cluster:
Using Calico: https://docs.projectcalico.org/v3.2/getting-started/kubernetes/installation/calico#installing-with-the-kubernetes-api-datastore50-nodes-or-less
Note: 50-nodes-or-less
```
kubeadm init --pod-network-cidr=192.168.0.0/16
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

Next start the pod networking (I am using Calico here):
```
kubectl apply -f https://docs.projectcalico.org/v3.2/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
kubectl apply -f https://docs.projectcalico.org/v3.2/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml
```

