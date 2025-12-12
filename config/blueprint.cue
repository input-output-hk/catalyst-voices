project: {
	name: "voices-frontend-config"

	release: {
		docker: {
			on: {
				// merge: {}
				// tag: {}
				always: {}
			}
			config: {
				tag: _ @forge(name="GIT_HASH_OR_TAG")
			}
		}
	}
}
