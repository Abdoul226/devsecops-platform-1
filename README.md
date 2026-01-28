# Cloud-Native DevSecOps Platform (AWS EKS + GitOps)

## 📌 Overview

This project demonstrates a **complete Cloud-Native DevSecOps platform** built on **AWS EKS**, following modern **CI/CD**, **Security-as-Code**, and **GitOps** best practices.

The goal of this project is to showcase a **production-like DevSecOps workflow**, from infrastructure provisioning to secure application delivery on Kubernetes.

The platform enforces:

* Automated testing
* Static code analysis with **quality gates**
* Container vulnerability scanning
* Immutable container images
* GitOps-based Kubernetes deployments

---

## 🧱 Architecture Overview

**High-level components:**

* **Terraform**: Infrastructure as Code (VPC, EKS, Node Groups)
* **Jenkins**: CI pipeline execution
* **SonarQube**: Static Application Security Testing (SAST)
* **Trivy**: Container image vulnerability scanning
* **Amazon ECR**: Container image registry
* **Argo CD**: GitOps-based continuous delivery
* **Amazon EKS**: Kubernetes runtime platform

> Jenkins never deploys directly to Kubernetes. All deployments are driven by Git through Argo CD.

---

## 🔄 CI/CD & GitOps Workflow

1. Developer pushes code to GitHub
2. Jenkins pipeline is triggered automatically
3. Application tests are executed
4. Static code analysis is performed using SonarQube
5. **Quality Gate blocks the pipeline if standards are not met**
6. Docker image is built
7. Image is scanned with Trivy for HIGH and CRITICAL vulnerabilities
8. Secure image is pushed to Amazon ECR
9. Jenkins updates the GitOps manifest with the new image tag
10. Argo CD detects the Git change and synchronizes the deployment to EKS

This approach ensures **traceability, reproducibility, and safe rollbacks**.

---

## 🛡️ Security Strategy

### SonarQube – Code Quality & SAST

* Enforces code quality and security rules
* Pipeline is blocked if the Quality Gate fails
* Ensures security issues are detected early in the SDLC

### Trivy – Container Security

* Scans Docker images for OS and dependency vulnerabilities
* Pipeline blocks on **HIGH and CRITICAL** vulnerabilities
* Uses `--ignore-unfixed` to reflect real-world security policies

> Vulnerabilities without available fixes are tracked but do not block delivery.

---

## ☸️ GitOps with Argo CD

* Kubernetes manifests are stored in Git
* Argo CD continuously monitors the Git repository
* Any change in Git is automatically applied to the cluster
* Provides:

  * Full audit trail
  * Easy rollback
  * Environment consistency

---

## 📁 Repository Structure

```
.
├── app/                    # Application source code
├── ci/
│   └── Jenkinsfile         # CI/CD pipeline definition
├── gitops/
│   └── apps/hello/         # Kubernetes manifests (GitOps)
├── terraform/
│   ├── modules/
│   └── environments/dev/  # AWS infrastructure (VPC + EKS)
├── tooling-vm/             # Jenkins & SonarQube (Docker Compose)
├── docs/                   # Project documentation
└── README.md
```

---

## 🧠 Key DevOps Concepts Demonstrated

* Infrastructure as Code (IaC)
* CI/CD pipelines
* DevSecOps (shift-left security)
* GitOps deployment model
* Kubernetes production practices
* Secure container supply chain

---

## 🎯 Why This Project Matters

This project reflects **real-world DevSecOps constraints**, including:

* Blocking pipelines with security gates
* Handling detached HEAD state in CI
* Secure Git authentication from Jenkins
* Separation of CI and CD responsibilities

It is designed as a **portfolio-grade project** for DevOps / Cloud / Platform Engineer roles.

---

## ▶️ How to Run & Reproduce the Project

This section explains how to reproduce the platform from scratch in a local AWS account.

### 1️⃣ Prerequisites

* AWS account
* AWS CLI configured (`aws configure`)
* Terraform >= 1.4
* kubectl
* Docker
* Git

---

### 2️⃣ Provision Infrastructure (Terraform)

From the repository root:

```bash
cd terraform/environments/dev
terraform init
terraform apply
```

This provisions:

* VPC
* EKS cluster
* Managed node group
* IAM roles and security groups

---

### 3️⃣ Access the Tooling VM (SSM)

```bash
aws ssm start-session --target <TOOLING_EC2_ID> --region eu-west-3
```

The tooling VM hosts:

* Jenkins
* SonarQube

---

### 4️⃣ Start Tooling Services

```bash
cd /opt/tooling
docker compose up -d
```

Services:

* Jenkins: [http://localhost:8080](http://localhost:8080)
* SonarQube: [http://localhost:9000](http://localhost:9000)

(Accessed via SSM port-forwarding)

---

### 5️⃣ Configure Jenkins

* Create a Pipeline job (Pipeline from SCM)
* Point to this repository
* Jenkinsfile path: `ci/Jenkinsfile`
* Add credentials:

  * AWS credentials (for ECR)
  * GitHub PAT (for GitOps push)

---

### 6️⃣ Configure SonarQube

* First login to SonarQube UI
* Create a project: `hello-app`
* Generate a token if needed
* Configure webhook:

```
http://jenkins:8080/sonarqube-webhook/
```

---

### 7️⃣ Deploy Argo CD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Expose Argo CD (port-forward or Ingress).

---

### 8️⃣ Run the Pipeline

* Push code to GitHub **or** click "Build Now" in Jenkins
* Observe pipeline stages:

  * Tests
  * SonarQube + Quality Gate
  * Trivy scan
  * Image push to ECR
  * GitOps manifest update

---

### 9️⃣ Validate Deployment

```bash
kubectl -n argocd get applications
kubectl -n hello get pods
kubectl -n hello get ingress
```

Access the application via the AWS ALB DNS name.

---

### 🔁 Rollback Strategy

Rollback is Git-driven:

```bash
git revert <gitops-commit>
git push
```

Argo CD automatically synchronizes the previous state.

---

## ▶️ How to Run (Quickstart)

This section provides a minimal set of steps to **reproduce the platform**.

### 1) Provision AWS infrastructure (Terraform)

From your local workstation:

```bash
cd terraform/environments/dev
terraform init
terraform plan
terraform apply
```

Configure kubectl:

```bash
aws eks update-kubeconfig --region eu-west-3 --name cn-devsec-dev
kubectl get nodes
```

### 2) Access the Tooling EC2 securely (SSM)

```bash
aws ssm start-session --region eu-west-3 --target <TOOLING_INSTANCE_ID>
```

Port-forward Jenkins (8080):

```bash
aws ssm start-session \
  --region eu-west-3 \
  --target <TOOLING_INSTANCE_ID> \
  --document-name AWS-StartPortForwardingSession \
  --parameters '{"portNumber":["8080"],"localPortNumber":["8080"]}'
```

Open: `http://localhost:8080`

Port-forward SonarQube (9000):

```bash
aws ssm start-session \
  --region eu-west-3 \
  --target <TOOLING_INSTANCE_ID> \
  --document-name AWS-StartPortForwardingSession \
  --parameters '{"portNumber":["9000"],"localPortNumber":["9000"]}'
```

Open: `http://localhost:9000`

### 3) Install Argo CD (EKS)

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
kubectl create namespace argocd || true
helm upgrade --install argocd argo/argo-cd -n argocd
kubectl -n argocd get pods
```

### 4) Deploy the GitOps root app

```bash
kubectl apply -f gitops/argocd/root-app.yaml
kubectl -n argocd get applications
```

### 5) Run the pipeline

* Jenkins job is configured as **Pipeline from SCM** using `ci/Jenkinsfile`
* Trigger a build (Build Now)
* Validate deployment:

```bash
kubectl -n argocd get applications
kubectl -n hello rollout status deploy/hello
kubectl -n hello get deploy hello -o=jsonpath='{.spec.template.spec.containers[0].image}'; echo
```

---

## 🚀 Future Improvements

* Multi-environment support (dev / staging / prod)
* Helm-based deployments
* Argo Rollouts (blue/green or canary)
* Monitoring with Prometheus & Grafana
* Policy-as-Code (OPA / Conftest)

---

## 👤 Author

**Abdoul Aziz Zongo**
DevOps / Cloud Engineer

---

> *Security, automation, and Git-driven delivery are first-class citizens in this platform.*

