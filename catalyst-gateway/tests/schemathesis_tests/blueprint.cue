version: "1.0.0"
project: {
	name: "gateway-schema-tests"
	ci: {
    targets: {
      "test-schemathesis": privileged: true
      "nightly-test-schemathesis": privileged: true
      "nightly-test-dev-schemathesis": privileged: true
    }
  }
}
