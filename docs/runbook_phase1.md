# Runbook Phase 1 — VPC + EKS + IRSA + AWS Load Balancer Controller

## Terraform
- cd terraform/environments/dev
- terraform init
- terraform plan
- terraform apply

## Kubeconfig
- aws eks update-kubeconfig --region eu-west-3 --name <cluster_name>
- kubectl get nodes

## IRSA / OIDC
- eksctl utils associate-iam-oidc-provider --region eu-west-3 --cluster <cluster_name> --approve

## AWS Load Balancer Controller
- curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
- aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json
- eksctl create iamserviceaccount --cluster <cluster_name> --region eu-west-3 --namespace kube-system --name aws-load-balancer-controller --attach-policy-arn arn:aws:iam::<account_id>:policy/AWSLoadBalancerControllerIAMPolicy --override-existing-serviceaccounts --approve
- helm repo add eks https://aws.github.io/eks-charts && helm repo update
- helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=<cluster_name> --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller --set region=eu-west-3 --set vpcId=<vpc_id>

## Checks
- kubectl -n kube-system get pods | grep aws-load-balancer-controller
- kubectl -n kube-system get sa aws-load-balancer-controller
