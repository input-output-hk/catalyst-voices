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
			always: {}
		}
		environment: "dev"
		modules: main: {
			container: "blueprint-deployment"
			version:   "0.2.4"
			values: {
				app: {
					environment: "dev"

					image: {
						repository: "332405224602.dkr.ecr.eu-central-1.amazonaws.com/gateway"
						tag:        _ @forge(name="GIT_HASH_OR_TAG")
					}

					containerPort: 3030
					strategy:      "Recreate"
					ingressHost:   "gateway.dev.project-catalyst.io"

					persistentVolumeClaims: [
						{
							name:             "pvc"
							storageClassName: "ebs-io1"
							storage:          "250Gi"
						},
					]

					volumes: [
						{
							name: "data"
							persistentVolumeClaim: {
								claimName: "pvc"
							}
						},
					]

					volumeMounts: [
						{
							name:      "data"
							mountPath: "/root/.local/share/cat-gateway"
							readOnly:  false
						},
					]

					env: [
						{
							name:  "RUST_LOG"
							value: "error,cat_gateway=info,cardano_chain_follower=info"
						},
						{
							name: "CASSANDRA_VOLATILE_URL"
							valueFrom: {
								secretKeyRef: {
									key: "cassandra-volatile-url"
								}
							}
						},
						{
							name: "CASSANDRA_VOLATILE_USERNAME"
							valueFrom: {
								secretKeyRef: {
									key: "cassandra-volatile-username"
								}
							}
						},
						{
							name: "CASSANDRA_VOLATILE_PASSWORD"
							valueFrom: {
								secretKeyRef: {
									key: "cassandra-volatile-password"
								}
							}
						},

						{
							name: "CASSANDRA_VOLATILE_DEPLOYMENT"
							valueFrom: {
								secretKeyRef: {
									key: "cassandra-volatile-deployment"
								}
							}
						},
						{
							name: "CASSANDRA_PERSISTENT_URL"
							valueFrom: {
								secretKeyRef: {
									key: "cassandra-persistent-url"
								}
							}
						},
						{
							name: "CASSANDRA_PERSISTENT_USERNAME"
							valueFrom: {
								secretKeyRef: {
									key: "cassandra-persistent-username"
								}
							}
						},
						// TODO: Re-enable when we have SSL working
						// {
						// 	name:  "CASSANDRA_VOLATILE_TLS_CERT"
						// 	value: "/tmp/keyspaces.crt"
						// },
						// {
						// 	name:  "CASSANDRA_PERSISTENT_TLS_CERT"
						// 	value: "/tmp/keyspaces.crt"
						// },
						{
							name: "CASSANDRA_PERSISTENT_PASSWORD"
							valueFrom: {
								secretKeyRef: {
									key: "cassandra-persistent-password"
								}
							}
						},

						{
							name: "CASSANDRA_PERSISTENT_DEPLOYMENT"
							valueFrom: {
								secretKeyRef: {
									key: "cassandra-persistent-deployment"
								}
							}
						},
					]

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

					// TODO: Re-enable when deployment is working
					// readinessProbe: {
					// 	httpGet: {
					// 		path: "/v1/health/ready"
					// 		port: 8080
					// 	}
					// }

					// livenessProbe: {
					// 	httpGet: {
					// 		path: "/v1/health/live"
					// 		port: 8080
					// 	}
					// }

					nodeSelector: {
						"node-group": "catalyst-gateway"
					}

					tolerations: [
						{
							key:      "app"
							operator: "Equal"
							value:    "catalyst-gateway"
							effect:   "NoSchedule"
						},
					]

					serviceAccount: "catalyst-gateway"
					replicas:       1

					externalSecret: {
						secretStore:     "cluster-secret-store"
						refreshInterval: "30m"
						dataFrom: ["dev/gateway"]
					}
				}
			}
		}
	}

	release: {
		docker: {
			on: {
				always: {}
			}
			config: {
				tag: _ @forge(name="GIT_COMMIT_HASH")
			}
		}
	}
}
