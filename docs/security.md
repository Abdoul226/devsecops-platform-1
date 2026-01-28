SonarQube is used to enforce code quality and security standards.
The pipeline is configured with a Quality Gate that blocks delivery
if critical issues are detected.

Trivy is configured to block HIGH and CRITICAL vulnerabilities.
The --ignore-unfixed option is used to reflect real-world policies,
where vulnerabilities without available fixes are tracked but do not
block delivery.

