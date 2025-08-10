project: {
	name: "gateway"
	ci: {
		targets: {
			test: privileged: true
		}
	}
	deployment: {
		on: {
            always: {}
			// merge: {}
			// tag: {}
		}

		bundle: {
			env:  string | *"test"
			_env: env
			modules: main: {
				name:    "app"
				version: "0.13.1"
				values: {
					stateful: {
						argo: wave: 1
						containers: gateway: {
							image: {
								name: _ @forge(name="CONTAINER_IMAGE")
								tag:  _ @forge(name="GIT_HASH_OR_TAG")
							}
							env: {
								"CARDANO_UTXO_CACHE_SIZE": {
									value: string | *"800"
								}
								"CARDANO_NATIVE_ASSETS_CACHE_SIZE": {
									value: string | *"800"
								}
								"CHAIN_NETWORK": {
									value: string | *"Preprod"
								}
								"RUST_LOG": {
									value: string | *"debug,cat_gateway=debug,cardano_chain_follower=info"
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
								"EVENT_DB_URL": {
									secret: {
										name: "db-url"
										key:  "url"
									}
								}
								"EVENT_DB_MAX_CONNECTIONS_SIZE": {
									secret: {
										name: "gateway"
										key:  "db-max-connections"
									}
								}
								"EVENT_DB_MAX_LIFETIME": {
									secret: {
										name: "gateway"
										key:  "db-max-lifetime"
									}
								}
								"EVENT_DB_MIN_IDLE": {
									secret: {
										name: "gateway"
										key:  "db-min-idle"
									}
								}
								"EVENT_DB_CONNECTION_TIMEOUT": {
									secret: {
										name: "gateway"
										key:  "db-connection-timeout"
									}
								}
								"INTERNAL_API_KEY": {
									secret: {
										name: "gateway"
										key:  "api-key"
									}
								}
							}
							ports: {
								metrics: port: 3030
							}
							probes: {
								liveness: {
									path: "/api/v1/health/live"
									port: 3030
								}
								readiness: {
									path: "/api/v1/health/ready"
									port: 3030
								}
							}
							mounts: {
								data: {
									ref: stateful: {}
									path:     "/root/.local/share/cat-gateway"
									readOnly: false
								}
							}
							resources: {
								requests: {
									cpu:    string | *"1"
									memory: string | *"8Gi"
								}
								limits: {
									cpu:    string | *"8"
									memory: string | *"12Gi"
								}
							}
						}
						nodeSelector: _ | *{
							"node-group": "catalyst-gateway"
						}
						replicas:       number | *3
						serviceAccount: string | *"catalyst-gateway"
						strategy:       string | *"RollingUpdate"
						tolerations: _ | *[
							{
								key:      "app"
								operator: "Equal"
								value:    "catalyst-gateway"
								effect:   "NoSchedule"
							},
						]
						volumes: {
							data: {
								class: "ebs-io1"
								size:  "250Gi"
							}
						}
					}

					jobs:
					{
						// "frontend-config": {
						// 	argo: {
						// 		hook: {
						// 			type: "PostSync"
						// 			deletePolicy: ["BeforeHookCreation"]
						// 		}
						// 	}
						// 	hashName: false
						// 	containers: main: {
						// 		image: {
						// 			name: "332405224602.dkr.ecr.eu-central-1.amazonaws.com/catalyst-voices/voices-frontend-config"
						// 			tag:  _ @forge(name="GIT_HASH_OR_TAG")
						// 		}
						// 		env: {
						// 			ENVIRONMENT: {
						// 				value: string | *_env
						// 			}
						// 			API_KEY: {
						// 				secret: {
						// 					name: "gateway"
						// 					key:  "api-key"
						// 				}
						// 			}
						// 		}
						// 	}
						// }
						migration: {
							argo: {
								hook: {
									type: "PreSync"
									deletePolicy: ["BeforeHookCreation"]
								}
							}
							hashName: false
							containers: main: {
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
										value: string | *"gateway"
									}
									DB_DESCRIPTION: {
										value: string | *"Gateway Event Database"
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
										value: string | *"true"
									}
									WITH_MIGRATIONS: {
										value: string | *"true"
									}
								}
							}
						}
					}

					dns: {
						createEndpoint: false
						subdomain:      "app"
					}
					route: {
						hostnames: ["reviews"]
						rules: [{
							matches: [{
								path: {
									type:  "PathPrefix"
									value: "/api/gateway"
								}
							}]
							filters: [{
								type: "URLRewrite"
								urlRewrite: {
									path: {
										type:               "ReplacePrefixMatch"
										replacePrefixMatch: "/api"
									}
								}
							}]
							target: {
								port: 3030
							}
						}]
					}

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
						ports: {
							metrics: 3030
						}
						scrape: true
					}
				}
			}
		}
	}

	release: {
		docker: {
			on: {
				merge: {}
				tag: {}
			}
			config: {
				tag: _ @forge(name="GIT_HASH_OR_TAG")
			}
		}
	}

}
