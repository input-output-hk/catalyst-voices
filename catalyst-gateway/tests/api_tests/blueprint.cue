project: {
	name: "gateway-api-tests"
	ci: {
		targets: {
			"test": privileged: true
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
