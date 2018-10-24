
# setup env vars
export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
export NAME=demo.nealblackburn.com
export KOPS_STATE_STORE=s3://demo-nealblackburn-com-state-store

# deploy cluster using kops
kops create cluster \
    --zones us-west-2a \
    --networking=weave \
    --bastion \
    --topology=private \
    --name=${NAME}

# deploy pod networking (done via kops init)

