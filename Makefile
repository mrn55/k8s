set-envs:
	export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
	export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
	export NAME=demo.nealblackburn.com
	export KOPS_STATE_STORE=s3://nealblackburn-kops-config-store
create-cluster:
	kops create cluster \
		--zones us-west-2a \
		--networking=weave \
		--bastion \
		--topology=private \
		--name=${NAME}
delete-cluster:
	kops delete cluster --name=${NAME}
delete-cluster-yes:
	kops delete cluster --name=${NAME} --yes
install-helm:
	helm init
rollout:
	helm install -f ~/helm/examples/wordpress.yaml --name wordpress stable/lamp
check-zone:
	aws ec2 describe-availability-zones --region us-west-2
edit-cluster:
	kops edit cluster ${NAME}
deploy-cluster:
	kops update cluster ${NAME} --yes
check-cluster:
	kops validate cluster
setup-tiller:
	kubectl create serviceaccount --namespace kube-system tiller
	kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
	kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
deploy-some-drupals:
	helm install --name blackbne1 stable/drupal --set ingress.annotations=traefik,ingress.enabled=true,ingress.hostname=blackbne.demo.nealblackburn.com
	helm install --name blackbne2 stable/drupal
	helm install --name blackbne3 stable/drupal
	helm install --name blackbne4 stable/drupal
deploy-some-drupals-yes:
	helm install --name blackbne stable/drupal --set ingress.annotations="traefik",ingress.enabled=true,ingress.hostname=blackbne.demo.nealblackburn.com
traefik-deploy:
	kubectl apply -f traefik-deployment.yaml
traefik-proxy:
	kubectl apply -f traefik-proxy.yaml
elb-address:
	kubectl describe service traefik-proxy | grep LoadBalancer
