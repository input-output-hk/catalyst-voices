version: "1.0.0"
project: {
	name: "gateway"
	ci: {
		targets: {
			test: privileged: true
		}
	}
	deployment: {
		on: {
			// TODO: Remove always before merging
			always: {}
		}
		environment: "dev"
		modules: main: {
			name:    "app"
			version: "0.3.2"
			values: {
				deployment: {
					containers: gateway: {
						image: {
							name: _ @forge(name="CONTAINER_IMAGE")
							tag:  _ @forge(name="GIT_HASH_OR_TAG")
						}

						env: {
							"RUST_LOG": {
								value: "error,cat_gateway=info,cardano_chain_follower=info"
							}
							"CASSANDRA_VOLATILE_URL": {
								secret: {
									name: "gateway"
									key:  "cassandra-volatile-url"
								}
							}
							"CASSANDRA_VOLATILE_USERNAME": {
								secret: {
									name: "gateway"
									key:  "cassandra-volatile-username"
								}
							}
							"CASSANDRA_VOLATILE_PASSWORD": {
								secret: {
									name: "gateway"
									key:  "cassandra-volatile-password"
								}
							}

							"CASSANDRA_VOLATILE_DEPLOYMENT": {
								secret: {
									name: "gateway"
									key:  "cassandra-volatile-deployment"
								}
							}
							"CASSANDRA_PERSISTENT_URL": {
								secret: {
									name: "gateway"
									key:  "cassandra-persistent-url"
								}
							}
							"CASSANDRA_PERSISTENT_USERNAME": {
								secret: {
									name: "gateway"
									key:  "cassandra-persistent-username"
								}
							}
							"CASSANDRA_PERSISTENT_PASSWORD": {
								secret: {
									name: "gateway"
									key:  "cassandra-persistent-password"
								}
							}
							"CASSANDRA_PERSISTENT_DEPLOYMENT": {
								secret: {
									name: "gateway"
									key:  "cassandra-persistent-deployment"
								}
							}
							"INTERNAL_API_KEY": {
								secret: {
									name: "gateway"
									key:  "api-key"
								}
							}
							"EVENT_DB_URL": {
								secret: {
									name: "db-url"
									key:  "url"
								}
							}
						}

						port: 3030
						probes: {
							liveness: path:  "/api/v1/health/live"
							readiness: path: "/api/v1/health/ready"
						}
						mounts: data: {
							ref: volume: name: "data"
							path:     "/root/.local/share/cat-gateway"
							readOnly: false
						}
						resources: {
							requests: {
								cpu:    "1"
								memory: "8Gi"
							}
							limits: {
								cpu:    "8"
								memory: "12Gi"
							}
						}
					}

					nodeSelector: {
						"node-group": "catalyst-gateway"
					}
					serviceAccount: "catalyst-gateway"
					strategy:       "Recreate"
					tolerations: [
						{
							key:      "app"
							operator: "Equal"
							value:    "catalyst-gateway"
							effect:   "NoSchedule"
						},
					]
				}

				jobs: migration: containers: main: {
					image: {
						name: "332405224602.dkr.ecr.eu-central-1.amazonaws.com/catalyst-voices/gateway-event-db"
						tag:  _ @forge(name="GIT_HASH_OR_TAG")
					}

					env: {
						DB_HOST: {
							secret: {
								name: "db"
								key:  "host"
							}
						}
						DB_PORT: {
							secret: {
								name: "db"
								key:  "port"
							}
						}
						DB_NAME: {
							value: "gateway"
						}
						DB_DESCRIPTION: {
							value: "Gateway Event Database"
						}
						DB_SUPERUSER: {
							secret: {
								name: "db-root"
								key:  "username"
							}
						}
						DB_SUPERUSER_PASSWORD: {
							secret: {
								name: "db-root"
								key:  "password"
							}
						}
						DB_USER: {
							secret: {
								name: "db"
								key:  "username"
							}
						}
						DB_USER_PASSWORD: {
							secret: {
								name: "db"
								key:  "password"
							}
						}
						INIT_AND_DROP_DB: {
							value: "true"
						}
						WITH_MIGRATIONS: {
							value: "true"
						}
					}
				}

				ingress: subdomain: "gateway"

				secrets: {
					db: {
						ref: "db/gateway"
					}
					"db-root": {
						ref: "db/root_account"
					}
					"db-url": {
						ref: "db/gateway"
						template: url: "postgres://{{ .username }}:{{ .password }}@{{ .host }}:{{ .port }}/gateway"
					}
					gateway: {
						ref: "gateway"
					}
				}

				service: {
					port: 80
					scrape: {}
				}

				volumes: data: {
					class: "ebs-io1"
					size:  "250Gi"
				}
			}
		}
	}

	release: {
		docker: {
			on: {
				// TODO: Remove always before merging
				always: {}
			}
			config: {
				tag: _ @forge(name="GIT_COMMIT_HASH")
			}
		}
	}
}
