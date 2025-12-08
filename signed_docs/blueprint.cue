project: {
	name: "setup-fund-documents"

	deployment: {
		on: {
			tag: {}
		}
		bundle: {
			env: string | *"dev"
			modules: main: {
				name:    "app"
				version: "0.11.1"
				values: {
					deployment: {
						replicas: 1
						containers: main: {
							image: {
								name: _ @forge(name="CONTAINER_IMAGE")
								tag:  _ @forge(name="GIT_HASH_OR_TAG")
							}
							env: {
								"ENVIRONMENT": {
									value: string | *"dev"
								}
								"CAT_GATEWAY_ADMIN_PRIVATE_KEY": {
									secret: {
										name: "setup-fund-documents"
										key:  "cat-gateway-admin-private-key"
									}
								}
							}
							resources: requests: {
								cpu:    string | *"256m"
								memory: string | *"256Mi"
							}
						}
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
