# Architecture — Cloud-Native DevSecOps Platform on AWS (EKS)

## Objectif
Plateforme Kubernetes EKS production-ready avec IaC (Terraform), CI DevSecOps (Jenkins/Sonar/Trivy), GitOps (ArgoCD), observabilité (Prometheus/Grafana) et sécurité (IRSA, policies).

## Diagramme
flowchart LR
  Dev[Dev / Laptop] -->|git push| GitApp[(Repo App)]
  Dev -->|git push| GitOps[(Repo GitOps)]

  subgraph Tooling[Tooling / CI-CD & Sec]
    Jenkins[Jenkins]
    Sonar[SonarQube]
    Trivy[Trivy]
  end

  GitApp --> Jenkins
  Jenkins -->|SAST/Quality| Sonar
  Jenkins -->|Image scan| Trivy
  Jenkins -->|Build & Push| ECR[(Amazon ECR)]
  Jenkins -->|Update image tag/values| GitOps

  subgraph AWS[AWS eu-west-3]
    subgraph Net[VPC]
      IGW[Internet Gateway]
      subgraph Public[Public Subnets (Multi-AZ)]
        ALB[ALB Ingress (AWS LB Controller)]
        NAT[NAT Gateway]
      end
      subgraph Private[Private Subnets (Multi-AZ)]
        EKS[EKS Cluster]
        Nodes[Managed Node Group]
        Apps[Workloads: app, monitoring]
      end
    end
  end

  GitOps --> Argo[ArgoCD in EKS]
  Argo -->|Sync| Apps
  Apps -->|Ingress| ALB
  ALB --> User[Users/Internet]

  subgraph Obs[Observability]
    Prom[Prometheus]
    Graf[Grafana]
    Alert[Alertmanager]
  end

  Apps --> Prom
  Prom --> Graf
  Prom --> Alert


## Composants
### AWS
- VPC (public/private, multi-AZ)
- NAT Gateway, IGW
- EKS, Managed Node Groups
- ECR
- ALB (via AWS LB Controller)
- (Optionnel) Route53, ACM, WAF, Secrets Manager

### CI/CD & GitOps
- Jenkins CI
- SonarQube
- Trivy
- Repo GitOps
- ArgoCD

### Observabilité
- Prometheus
- Grafana
- Alertmanager (option)

## Flux
1) Code push → Jenkins
2) Jenkins build/test/scan → push ECR
3) Jenkins update repo GitOps
4) ArgoCD sync → EKS
5) Ingress → ALB → Users

