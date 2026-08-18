<div align="center">

<img alt="rackctl — the day-0 installer for a nanohype platform" src="https://raw.githubusercontent.com/rackctl/.github/main/profile/assets/hero.svg" width="840">

<p>
  <b>Zero to a running platform, in one command.</b><br />
  rackctl takes an empty AWS account to a reconciling
  <a href="https://github.com/nanohype">nanohype</a> platform — cloud, cluster, GitOps,
  controllers — then hands off to the portal for day-2 operations. It automates the manual
  runbook and kills the footguns.
</p>

<p>
  <a href="https://rackctl.sh"><img alt="rackctl.sh" src="https://img.shields.io/badge/rackctl.sh-9bb0d0?style=flat-square&logoColor=white"></a>
  <img alt="Apache-2.0" src="https://img.shields.io/badge/license-Apache--2.0-8b93a6?style=flat-square">
  <img alt="AWS only" src="https://img.shields.io/badge/AWS-only-9bb0d0?style=flat-square&logo=amazonaws&logoColor=white">
  <img alt="OpenTofu" src="https://img.shields.io/badge/OpenTofu-9bb0d0?style=flat-square&logo=opentofu&logoColor=white">
  <img alt="Kubernetes" src="https://img.shields.io/badge/Kubernetes-9bb0d0?style=flat-square&logo=kubernetes&logoColor=white">
</p>

</div>

```sh
curl -fsSL rackctl.sh/install | sh
```

<table>
  <tr><td colspan="2"><sub><b>THE TOOL</b></sub></td></tr>
  <tr>
    <td valign="top"><a href="https://github.com/rackctl/rackctl"><b>rackctl</b></a></td>
    <td>The day-0 installer. <code>rackctl apply</code> takes an operator from zero to a running, nanohype-shaped platform — an orchestrator over landing-zone (Terragrunt), eks-gitops (ArgoCD), and eks-agent-platform (operator), not a rewrite. <code>plan</code> is read-only; a failed <code>apply</code> tears down in reverse. Go · cobra · bubbletea.</td>
  </tr>
  <tr>
    <td valign="top"><a href="https://github.com/rackctl/homebrew-tap"><b>homebrew-tap</b></a></td>
    <td>The Homebrew tap — <code>brew install rackctl/tap/rackctl</code>.</td>
  </tr>

  <tr><td colspan="2"><sub><b>THE SITE &amp; INFRA</b></sub></td></tr>
  <tr>
    <td valign="top"><a href="https://github.com/rackctl/web"><b>web</b></a></td>
    <td><a href="https://rackctl.sh">rackctl.sh</a> — the landing page. Vite · React 19 · Tailwind v4 on the shuttering design system.</td>
  </tr>
  <tr>
    <td valign="top"><a href="https://github.com/rackctl/docs"><b>docs</b></a></td>
    <td><a href="https://docs.rackctl.sh">docs.rackctl.sh</a> — the documentation. Install, quickstart, the <code>rackctl.yaml</code> reference, the pipeline, and the footguns. Astro · Starlight on the shuttering docs theme (<code>@shuttering/starlight</code>), slate ground + steel accent.</td>
  </tr>
  <tr>
    <td valign="top"><a href="https://github.com/rackctl/infra"><b>infra</b></a></td>
    <td>The AWS deploy — OpenTofu + Terragrunt (S3 · CloudFront · ACM · Route53) serving rackctl.sh and the installer.</td>
  </tr>
</table>

<sub>Built on <a href="https://github.com/nanohype">nanohype</a>. Apache-2.0.</sub>
