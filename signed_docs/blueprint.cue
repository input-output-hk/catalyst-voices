project: {
	name: "setup-fund-documents"

	release: {
		docker: {
			on: {
				tag: {}
			}
			config: {
				tag: _ @forge(name="GIT_HASH_OR_TAG")
			}
		}
	}
}
