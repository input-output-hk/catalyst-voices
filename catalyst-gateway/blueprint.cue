version: "1.0.0"
project: {
	name: "gateway"
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
	ci: {
    targets: {
      "test-postgres": privileged: true
    }
  }
}
