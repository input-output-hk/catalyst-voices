project: {
	name: "catalyst-gateway-tests"
	ci: {
		targets: {
			"test-postgres": privileged: true
			"test-scylla": privileged:   true
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
