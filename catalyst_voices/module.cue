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
