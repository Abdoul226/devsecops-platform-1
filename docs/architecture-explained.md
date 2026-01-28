# Architecture (Explained) — Cloud-Native DevSecOps Platform

## Objective
Build and operate a production-like DevSecOps platform on AWS:
- Kubernetes runtime on **EKS**
- **CI** with Jenkins
- **Security gates** with SonarQube (SAST) and Trivy (image scanning)
- **GitOps CD** with Argo CD
- Controlled, auditable deployments driven by Git (not by Jenkins)

---

## High-level diagram (explained)

┌──────────────────────────────┐
│ Developer workstation         │
│ (Git push)                    │
└───────────────┬──────────────┘
                │
                v
┌──────────────────────────────┐
│ GitHub Repository             │
│ - app/ (source)               │
│ - ci/Jenkinsfile              │
│ - gitops/ (K8s manifests)     │
└───────────────┬──────────────┘
                │ (Pipeline from SCM)
                v
┌─────────────────────────────────────────────────────────────────┐
│ Tooling EC2 (AWS)                                                │
│                                                                 │
│  ┌───────────────┐     ┌───────────────┐     ┌───────────────┐  │
│  │ Jenkins        │ --> │ SonarQube      │ --> │ Quality Gate   │  │
│  │ (CI Pipeline)  │     │ (SAST/Quality) │     │ (block/allow)  │  │
│  └───────┬───────┘     └───────────────┘     └───────────────┘  │
│          │                                                     │
│          v                                                     │
│   ┌───────────────┐     ┌───────────────────────────────────┐  │
│   │ Docker Build   │ --> │ Trivy Scan (HIGH/CRITICAL)         │  │
│   │ (immutable img)│     │ + ignore-unfixed (policy)          │  │
│   └───────┬───────┘     └───────────────────────────────────┘  │
│          │                                                     │
│          v                                                     │
│   ┌──────────────────────────────┐                            │
│   │ Amazon ECR (registry)         │                            │
│   │ - stores versioned images     │                            │
│   └───────────────┬──────────────┘                            │
│                   │                                            │
│                   v                                            │
│   ┌─────────────────────────────────────────────────────────┐  │
│   │ GitOps update (commit manifest with new image tag)       │  │
│   └─────────────────────────────────────────────────────────┘  │
└──────────────────────────────┬──────────────────────────────────┘
                               │ (Argo watches Git)
                               v
┌─────────────────────────────────────────────────────────────────┐
│ AWS EKS (Kubernetes)                                              │
│                                                                 │
│  ┌──────────────────────────────┐                               │
│  │ Argo CD (GitOps CD)          │                               │
│  │ - pulls manifests from Git    │                               │
│  │ - syncs cluster state         │                               │
│  └───────────────┬──────────────┘                               │
│                  │                                              │
│                  v                                              │
│  ┌──────────────────────────────┐                               │
│  │ hello namespace               │                               │
│  │ - Deployment/Service/Ingress  │                               │
│  └───────────────┬──────────────┘                               │
│                  │                                              │
│                  v                                              │
│  ┌──────────────────────────────┐                               │
│  │ AWS Load Balancer Controller  │                               │
│  │ -> provisions ALB             │                               │
│  └───────────────┬──────────────┘                               │
└──────────────────┼──────────────────────────────────────────────┘
                   │
                   v
        ┌──────────────────────────┐
        │ Public ALB Endpoint       │
        │ http(s)://<alb-dns>       │
        └──────────────────────────┘

---

## Key design decisions (and why)

### 1) Separation of responsibilities: CI ≠ CD
- Jenkins is responsible for building noted artifacts (container images) and verifying security/quality.
- Argo CD is responsible for deploying to Kubernetes.
✅ This avoids “Jenkins deploying directly to prod” and provides an audit trail through Git.

### 2) Immutable images + versioned registry (ECR)
- Every build creates a unique tag (`v0.1.<build_number>`).
- ECR stores immutable artifacts and keeps history.

### 3) Security gates are enforced (DevSecOps)
- SonarQube blocks pipeline if the Quality Gate fails.
- Trivy blocks delivery on HIGH/CRITICAL vulnerabilities (with `--ignore-unfixed` policy).

### 4) GitOps provides traceability and rollback
- The deployed version is always defined in Git.
- Rolling back is a Git revert.

### 5) AWS Load Balancer Controller for real-world ingress
- ALB provisioning is managed by Kubernetes Ingress resources.
- This reflects standard AWS production practices.

---

## What you can demo quickly
1) Trigger a Jenkins build
2) Show SonarQube analysis + Quality Gate
3) Show Trivy report and pass/fail behavior
4) Show image tag pushed to ECR
5) Show GitOps manifest updated by Jenkins
6) Show Argo CD sync and new version running in EKS
7) Open the ALB URL and confirm the served version

