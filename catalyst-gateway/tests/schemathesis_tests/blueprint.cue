project: {
	name: "gateway-schema-tests"
	ci: {
    targets: {
      "test-ci-schemathesis": privileged: true
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
