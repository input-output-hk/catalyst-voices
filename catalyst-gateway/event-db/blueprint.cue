version: "1.0.0"
project: {
	name: "gateway-event-db"
	release: {
		docker: {
			on: {
				//merge: {}
				//tag: {}
				always: {}
			}
			config: {
				tag: _ @forge(name="GIT_HASH_OR_TAG")
			}
		}
	}
}