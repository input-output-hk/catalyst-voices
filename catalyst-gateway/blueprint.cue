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
			version:   "0.2.3"
			values: {
				app: {
					environment: "dev"

					image: {
						repository: "332405224602.dkr.ecr.eu-central-1.amazonaws.com/gateway"
						tag:        _ @forge(name="GIT_HASH_OR_TAG")
					}

					containerPort: 8080

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
						{
							name: "keyspaces-certificate"
							secret: {
								items: [
									{
										key:  "keyspaces-crt"
										path: "sf-class2-root.crt"
									},
								]
							}
						},
					]

					volumeMounts: [
						{
							name:      "keyspaces-certificate"
							mountPath: "/tmp"
						},
						{
							name:      "data"
							mountPath: "/data"
							readOnly:  false
						},
					]

					env: [
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
							name:  "CASSANDRA_VOLATILE_TLS"
							value: "/tmp/sf-class2-root.crt"
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
							name: "CASSANDRA_VOLATILE_DEPLOYMENT_LATENCY"
							valueFrom: {
								secretKeyRef: {
									key: "cassandra-volatile-deployment-latency"
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
						{
							name: "CASSANDRA_PERSISTENT_PASSWORD"
							valueFrom: {
								secretKeyRef: {
									key: "cassandra-persistent-password"
								}
							}
						},
						{
							name:  "CASSANDRA_PERSISTENT_TLS"
							value: "/tmp/sf-class2-root.crt"
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
							name: "CASSANDRA_PERSISTENT_DEPLOYMENT_LATENCY"
							valueFrom: {
								secretKeyRef: {
									key: "cassandra-persistent-deployment-latency"
								}
							}
						},
					]

					readinessProbe: {
						httpGet: {
							path: "/v1/health/ready"
							port: 8080
						}
					}

					livenessProbe: {
						httpGet: {
							path: "/v1/health/live"
							port: 8080
						}
					}

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
