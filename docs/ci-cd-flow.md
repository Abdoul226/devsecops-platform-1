# CI/CD Flow — Jenkins + SonarQube + Trivy + ECR + Argo CD

## Pipeline stages
1. Checkout
2. Tests
3. SonarQube Analysis
4. Quality Gate (blocking)
5. Build Docker image
6. Trivy Scan (blocking)
7. Push image to ECR
8. Update GitOps manifest (commit & push)
9. Argo CD syncs and deploys to EKS

## Why GitOps
- CI does not have cluster credentials or deploy permissions
- All deployments are Git-driven (auditable, reproducible)
- Rollback is a Git revert

## Security policy
- Block HIGH/CRITICAL vulnerabilities
- Use `--ignore-unfixed` to reflect real-world policies
  (track vulnerabilities without a fix, but do not block delivery)

## Common failure modes and fixes
- Detached HEAD during CI → push with `git push origin HEAD:main`
- Git push over HTTPS requires PAT → Jenkins credentials injection
- SonarQube Quality Gate needs webhook → configure SonarQube webhook to Jenkins

