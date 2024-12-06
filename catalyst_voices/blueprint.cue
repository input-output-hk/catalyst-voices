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
			container: "voices-deployment"
			version:   "0.1.1"
			values: {
				environment: name: "dev"
				frontend: image: {
					tag: _ @forge(name="GIT_HASH_OR_TAG")
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
