version: "1.0.0"
project: {
	name: "gateway"
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
