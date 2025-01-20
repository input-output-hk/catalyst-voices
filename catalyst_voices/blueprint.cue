version: "1.0.0"
project: {
	name: "voices"
	deployment: {
		on: {
			merge: {}
			tag: {}
		}
		environment: "dev"
		modules: main: {
			name:    "app"
			version: "0.2.1"
			values: {
				deployment: containers: main: {
					image: {
						name: _ @forge(name="CONTAINER_IMAGE")
						tag:  _ @forge(name="GIT_HASH_OR_TAG")
					}
					port: 80
					probes: {
						liveness: path:  "/"
						readiness: path: "/"
					}
				}
				ingress: subdomain: "voices"
				service: {
					targetPort: 80
					port:       80
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
