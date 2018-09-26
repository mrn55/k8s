# k8s

## Setup env vars

```bash
export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)

export NAME=demo.nealblackburn.com
export KOPS_STATE_STORE=s3://demo-nealblackburn-com-state-store
```

## Check zone

```bash
aws ec2 describe-availability-zones --region us-west-2
# you should see a list like 2a, 2b, 2c with State: available for 
# the one you want to deploy in
```

## Create cluster
Now we'll create the cluster, you can pass in more information here or follow through to the next command and edit it as well.

Worth noting, you can have a multi zone by passing it a csv like: us-west-2a, us-east-1a

```bash
kops create cluster \
--zones us-west-2a \
--networking=weave \
--bastion \
--topology=private \
--name=${NAME}

# Remember this will be a dry run look at "deploy cluster" below to apply
```

## Edit cluster
Remember this configuration is pulled and stored on S3

```bash
kops edit cluster ${NAME}
```

## Deploy cluster
For when you are ready to spin it up

```bash
kops update cluster ${NAME} --yes
```

## Check cluster
There are a cuple commands you can use. By now you can use the `kubectl` command as kops has configured your ~/.kube/config and it should point correctly.

```bash
kubectl get nodes

# validate cluster is a great tool to check the overall health
kops validate cluster

# to report all your pods and their status:
kubectl -n kube-system get pod
```

## Use cluster

Take a look at my [Helm Install and Useage](helm.md) for some possible next steps there.

## delete cluster

```bash
kops delete cluster --name ${NAME}

# without the --yes the delete will not apply, it will do a dry run/report what will happen.
# Try to not get into the habbit of passing --yes to all these commands until you are more confident...
kops delete cluster --name ${NAME] --yes
```

