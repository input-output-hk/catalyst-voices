version: "1.0.0"
project: {
  name: "gateway-api-tests"
  ci: {
    targets: {
      "test": privileged: true
      "nightly-test-dev": privileged: true
    }
  }
}