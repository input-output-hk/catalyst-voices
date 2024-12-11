version: "1.0.0"
project: {
	name: "gateway"
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

					containerPort: 8080
					strategy:      "Recreate"

					persistentVolumeClaims: [
						{
							name:             "pvc"
							storageClassName: "ebs"
							storage:          "10Gi"
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
							mountPath: "/var/lib"
							readOnly:  false
						},
					]

					env: [
						// TODO: Remove after deployment is working
						{
							name:  "DEBUG_SLEEP_ERR"
							value: "3600"
						},
						{
							name:  "RUST_LOG"
							value: "error,cat_gateway=debug,cardano_chain_follower=debug,mithril-client=debug"
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
							name:  "CASSANDRA_VOLATILE_TLS_CERT"
							value: "/tmp/keyspaces.crt"
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
							name:  "CASSANDRA_VOLATILE_DEPLOYMENT_LATENCY"
							value: "90"
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
						{
							name: "CASSANDRA_PERSISTENT_PASSWORD"
							valueFrom: {
								secretKeyRef: {
									key: "cassandra-persistent-password"
								}
							}
						},
						{
							name:  "CASSANDRA_PERSISTENT_TLS_CERT"
							value: "/tmp/keyspaces.crt"
						},
						{
							name: "CASSANDRA_PERSISTENT_DEPLOYMENT"
							valueFrom: {
								secretKeyRef: {
									key: "cassandra-persistent-deployment"
								}
							}
						},
						{
							name:  "CASSANDRA_PERSISTENT_DEPLOYMENT_LATENCY"
							value: "90"
						},
					]

					resources: {
						requests: {
							cpu:    "1"
							memory: "2Gi"
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
