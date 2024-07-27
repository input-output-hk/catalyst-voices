// Testing the wasm binding JS functions.

import init, {
	generate,
	verify,
	decode,
	PublicKey,
	PrivateKey,
} from "../../pkg/c509_certificate.js";

const pem_sk = `
-----BEGIN PRIVATE KEY-----
MC4CAQAwBQYDK2VwBCIEIP1iI3LF7h89yY6QZmhDp4Y5FmTQ4oasbz2lEiaqqTzV
-----END PRIVATE KEY-----
`;

const pem_pk = `
-----BEGIN PUBLIC KEY-----
MCowBQYDK2VwAyEAtFuCleJwHS28jUCT+ulLl5c1+MXhehhDz2SimOhmWaI=
-----END PUBLIC KEY-----
`;

const tbs = {
	c509_certificate_type: 0,
	certificate_serial_number: 1000000n,
	issuer: {
		relative_distinguished_name: [
			{
				oid: "2.5.4.3",
				value: [{ text: "RFC test CA" }],
			},
		],
	},
	validity_not_before: 1_672_531_200n,
	validity_not_after: 1_767_225_600n,
	subject: { text: "01-23-45-ff-fe-67-89-AB" },
	subject_public_key_algorithm: {
		oid: "1.3.101.112",
	},
	subject_public_key: [],
	extensions: [
		{
			oid: "2.5.29.19",
			value: { int: -2n },
			critical: false,
		},
	],
	issuer_signature_algorithm: {
		oid: "1.3.101.112",
	},
};

async function run() {
	await init();

	let sk = PrivateKey.str_to_sk(pem_sk);
	let pk = PublicKey.str_to_pk(pem_pk);

	// Call the generate with private key to create a signed version
	let c509 = generate(tbs, sk);
	console.log(c509);
	// Verify the generated C509 with the public key
	console.log(verify(c509, pk));
	// Decode the generated C509 back to readable format
	let decoded_c509 = decode(c509);
	console.log(decoded_c509.tbs_cert);
}

run();
