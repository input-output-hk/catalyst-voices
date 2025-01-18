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
			version: "0.2.1"
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

				ingress: subdomain: "gateway"

				secrets: gateway: {
					ref: "gateway"
				}

				service: {
					port:       80
					targetPort: 3030
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
