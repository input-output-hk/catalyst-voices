version: "1.0.0"
project: {
	name: "voices"
	deployment: {
		environment: "dev"
		modules: main: {
			container: "voices-deployment"
			version:   "0.1.1"
			values: {
				environment: name: "dev"
				frontend: image: {
					tag: _ @forge(name="GIT_COMMIT_HASH")
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
				tag: _ @forge(name="GIT_COMMIT_HASH")
			}
		}
	}
}
