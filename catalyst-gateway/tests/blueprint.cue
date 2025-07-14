project: {
	name: "catalyst-gateway-tests"
	ci: {
		targets: {
			"test-postgres": privileged: true
			"test-scylla": privileged:   true
		}
	}
}
