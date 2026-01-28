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

