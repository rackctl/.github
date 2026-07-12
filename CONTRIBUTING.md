# Contributing to rackctl

Thanks for your interest. rackctl is an orchestrator for the
[nanohype](https://github.com/nanohype) platform — small, sharp, AWS-only (v1).

## Workflow

- `main` is protected; all changes land through a pull request.
- Keep PRs focused. The commit message is the record — explain *why*, not just
  *what* (the diff shows what). Structured messages are welcome for large changes.
- CI must be green before merge: `gofmt`, `go vet`, `go test -race`, `govulncheck`
  for Go repos; `typecheck` + `build` for the web repo; `tofu fmt` + `validate`
  for infra.
- Merges are squash-merges that preserve the authored commit message.

## Local development

Each repo's `README.md` has its own build/test instructions. In short:

- **rackctl** (Go): `make build` · `make test` · `make vet fmt`.
- **web** (pnpm): `pnpm install` · `pnpm dev` · `pnpm build` (needs a
  `read:packages` token for the private `@shuttering` scope).
- **infra** (OpenTofu + Terragrunt): see `iac/README.md`.

## Reporting bugs

Open an issue with the command you ran, the output, and your OS/versions. For a
security issue, follow [SECURITY.md](./SECURITY.md) instead of filing publicly.
