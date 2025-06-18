{
	_#def
	_#def: {
		env: string | *"dev"
		modules: {
			[string]: {
				instance?: string
				name?:     string
				namespace: string | *"default"
				path?:     string
				registry?: string
				type:      string | *"kcl"
				values?:   _
				version?:  string
			}
		}
	} & {
		modules: {
			main: {
				name:     "app"
				version:  "0.11.0"
				instance: "voices"
				registry: "332405224602.dkr.ecr.eu-central-1.amazonaws.com/catalyst-deployments"
				values: {
					deployment: {
						containers: {
							main: {
								image: {
									name: "332405224602.dkr.ecr.eu-central-1.amazonaws.com/catalyst-voices/voices" @forge(name="CONTAINER_IMAGE")
									tag:  "524b3a15012a5c1f06cec35e57696d7f46cb2db9"                               @forge(name="GIT_HASH_OR_TAG")
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
									http: {
										port: 8080
									}
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
						}
					}
					configs: {
						caddy: {
							data: {
								Caddyfile: """
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
							}
						}
					}
					dns: {
						subdomain: "app"
					}
					route: {
						rules: [{
							matches: [{
								path: {
									type:  "PathPrefix"
									value: "/"
								}
							}]
							target: {
								port: 8080
							}
						}]
					}
					service: {
						scrape: true
					}
				}
			}
		}
	}
}
