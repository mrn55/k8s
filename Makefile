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
	helm install stable/drupal --name blackbne1 -f drupal.yaml --set ingress.hostname=blackbne1.training.drupal.oregonstate.edu
	helm install stable/drupal --name blackbne2 -f drupal.yaml --set ingress.hostname=blackbne2.training.drupal.oregonstate.edu
	helm install stable/drupal --name blackbne3 -f drupal.yaml --set ingress.hostname=blackbne3.training.drupal.oregonstate.edu
	helm install stable/drupal --name blackbne4 -f drupal.yaml --set ingress.hostname=blackbne4.training.drupal.oregonstate.edu
	helm install stable/drupal --name blackbne5 -f drupal.yaml --set ingress.hostname=blackbne5.training.drupal.oregonstate.edu
traefik-deploy:
	kubectl apply -f traefik-deployment.yaml
traefik-proxy:
	kubectl apply -f traefik-proxy.yaml
elb-address:
	kubectl describe service traefik-proxy | grep LoadBalancer
