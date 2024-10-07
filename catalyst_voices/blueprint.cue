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
					tag: _ @env(name="GIT_IMAGE_TAG",type="string")
				}
			}
		}
	}
}
