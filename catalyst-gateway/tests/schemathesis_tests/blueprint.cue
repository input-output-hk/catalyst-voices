project: {
	name: "gateway-schema-tests"
	ci: {
		targets: {
			"test-ci-schemathesis": privileged:            true
			"nightly-test-draft-schemathesis": privileged: true
			"nightly-test-dev-schemathesis": privileged:   true
		}
	}
}
