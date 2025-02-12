version: "1.0.0"
project: {
  name: "catalyst-gateway-tests"
  ci: {
    targets: {
      "test-postgres": privileged: true
      "test-scylla": privileged: true
    }
  }
}
