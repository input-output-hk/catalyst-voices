version: "1.0.0"
project: {
    name: "gateway-schema-tests"
    ci: {
        targets: {
            test-fuzzer-api: privileged: true
        }
}