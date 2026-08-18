# Security Policy

## Reporting a vulnerability

Please **do not** open a public issue for a security vulnerability.

Report it privately via GitHub's [security advisory](https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing-information-about-vulnerabilities/privately-reporting-a-security-vulnerability)
flow on the affected repository (Security → Report a vulnerability). Include the
affected version, reproduction steps, and impact.

We aim to acknowledge within a few business days and to coordinate a fix and
disclosure timeline with you.

## Scope

rackctl runs on the operator's own AWS credentials and shells out to
`tofu`/`terragrunt`/`kubectl`/`helm`/`aws`/`git`/`gh` — it holds no long-lived
secrets of its own. Reports about credential handling, command construction, the
installer download path, or the release supply chain are especially welcome.
