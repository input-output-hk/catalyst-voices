project: {
	name: "voices"
	ci: targets: {
		"package": {
			secrets: [
				{
					provider: "aws"
					path:     "global/ci/sentry"
					maps: {
						"token":   "SENTRY_AUTH_TOKEN"
					}
				},
			]
		}
		"docker": {
			secrets: [
				{
					provider: "aws"
					path:     "global/ci/sentry"
					maps: {
						"token":   "SENTRY_AUTH_TOKEN"
					}
				},
			]
		}
	}
	deployment: {
		on: {
			tag: {}
		}

		bundle: {
			env: string | *"dev"
			modules: main: {
				name:    "app"
				version: "0.11.1"
				values: {
					deployment: {
						replicas: number | *1
						containers: main: {
							image: {
								name: _ @forge(name="CONTAINER_IMAGE")
								tag:  _ @forge(name="GIT_HASH_OR_TAG")
							}
							mounts: {
								config: {
									ref: {
										config: {
											name: "caddy"
										}
									}
									path:    "/etc/caddy/Caddyfile"
									subPath: "Caddyfile"
								}
							}
							ports: {
								http: port:    8080
								metrics: port: 8081
							}
							probes: {
								liveness: {
									path: "/healthz"
									port: 8080
								}
								readiness: {
									path: "/healthz"
									port: 8080
								}
							}
							resources: requests: {
								cpu:    string | *"256m"
								memory: string | *"256Mi"
							}
						}
					}

					configs: caddy: data: "Caddyfile": """
						{
						  admin :8081
						  metrics
						}
						http://:8080 {
							root * /app

							encode

							handle /healthz {
							  respond `{"status":"ok"}` 200
							}

							handle {
							  try_files {path} /index.html
							  file_server {
							    precompressed
							  }
							}

							header {
							  Cross-Origin-Opener-Policy "same-origin"
							  Cross-Origin-Embedder-Policy "require-corp"
							  Cross-Origin-Resource-Policy "same-origin"

							  ?Cache-Control "public, max-age=3600, must-revalidate"
							}

							@index_html path /index.html
							header @index_html Cache-Control "no-cache, must-revalidate"

							import /app/versioned_assets.caddy

							handle_errors {
							  rewrite * /50x.html
							  file_server
							}

							log
						}
						"""

					dns: subdomain: "app"
					route: {
						rules: [
							{
								matches: [
									{
										path: {
											type:  "PathPrefix"
											value: "/"
										}
									},
								]
								target: port: 8080
							},
						]
					}

					service: {
						scrape: true
					}
				}
			}
		}
	}

	release: {
		docker: {
			on: {
				tag: {}
			}
			config: {
				tag: _ @forge(name="GIT_HASH_OR_TAG")
			}
		}
	}
}
