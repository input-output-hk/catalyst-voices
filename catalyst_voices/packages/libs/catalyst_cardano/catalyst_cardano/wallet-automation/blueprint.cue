project: {
	name: "voices-wallet-automation-test"
	ci: {
		targets: {
			"nightly-package-test": tags: ["nightly"]
			"nightly-build-web": tags: ["nightly"]
			"nightly-package-app": tags: ["nightly"]
		}
	}
}
