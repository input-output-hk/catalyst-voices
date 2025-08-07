global: {
	ci: {
		local: [
			"^check(-.*)?$",
			"^build(-.*)?$",
			"^package(-.*)?$",
			"^test(-.*)?$",
		]
		registries: [
			ci.providers.aws.ecr.registry,
		]
		release: docs: {
			bucket: "docs.dev.projectcatalyst.io"
			url:    "https://docs.dev.projectcatalyst.io/"
		}
		providers: {
			aws: {
				region: "eu-central-1"
				ecr: registry: "332405224602.dkr.ecr.eu-central-1.amazonaws.com"
				role: "arn:aws:iam::332405224602:role/ci"
			}

			docker: credentials: {
				provider: "aws"
				path:     "global/ci/docker"
			}

			git: credentials: {
				provider: "aws"
				path:     "global/ci/deploy"
			}

			earthly: {
				satellite: credentials: {
					provider: "aws"
					path:     "global/ci/ci-tls"
				}
				version: "0.8.16"
			}

			github: registry: "ghcr.io"

			tailscale: {
				credentials: {
					provider: "aws"
					path:     "global/ci/tailscale"
				}
				tags:    "tag:cat-github"
				version: "latest"
			}
		}
		retries: {
			attempts: 2
			filters: [
				"buildkitd did not respond",
			]
		}
		secrets: [
			{
				name:     "GITHUB_TOKEN"
				optional: true
				provider: "env"
				path:     "GITHUB_TOKEN"
			},
		]
	}
	deployment: {
		registries: {
			containers: ci.providers.aws.ecr.registry
			modules:    ci.providers.aws.ecr.registry + "/catalyst-deployments"
		}
		repo: {
			url: "https://github.com/input-output-hk/catalyst-world"
			ref: "master"
		}
		root: "k8s"
	}
	repo: {
		defaultBranch: "main"
		name:          "input-output-hk/catalyst-voices"
	}
}
