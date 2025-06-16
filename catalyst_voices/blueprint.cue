version: "1.0.0"
project: {
	name: "voices"
	deployment: {
		on: {
			merge: {}
			tag: {}
		}

		bundle: {
			modules: main: {
				name:    "app"
				version: "0.11.0"
				values: {
					deployment: containers: main: {
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
							http: port: 8080
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
					}

					configs: caddy: data: "Caddyfile": """
						localhost:8080 {
						  root * /app

						  file_server {
                            try_files {path} {path}/ /index.html
                          }

						  header {
							Cross-Origin-Opener-Policy "same-origin"
							Cross-Origin-Embedder-Policy "require-corp"

							/ Cache-Control "public, max-age=3600, must-revalidate"
						  }

						  respond /healthz `{"status": "ok"}` 200

						  route /metrics {
						    @local remote_ip 127.0.0.1
							require local
						    metrics
						  }

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
				//merge: {}
				//tag: {}
				always: {}
			}
			config: {
				tag: _ @forge(name="GIT_HASH_OR_TAG")
			}
		}
	}
}
