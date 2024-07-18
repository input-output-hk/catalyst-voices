import init, { generate, test, test2, TbsCert, UnwrappedBigUint } from "./pkg/c509_certificate.js";
async function run() {
    await init();
    let x = new UnwrappedBigUint(1000000n);
    let tbs = {
        version: 2,
        serial_number: 1000000n,
        issuer: {
            Text: "US",
        },
    };
    generate(tbs, "");

    // console.log(tbs);
    // console.log(test2(1000000n))
    // console.log(x);
}
run();