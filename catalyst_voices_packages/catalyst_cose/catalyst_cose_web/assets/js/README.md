# catalyst_cose_js

## How to make changes in JS layer?

catalyst_cose depends on the [cose-js](https://www.npmjs.com/package/cose-js)
node module which doesn't work out of the box on the browser without the node environment.

To make it compatible with the browser we employ the [browserify](https://browserify.org/)
which transforms the JS code to be browser runnable.

To make changes in JS layer take the following steps:

1. run `cd assets/js` # enter the directory.
2. run `npm install` to init the node environment.
3. Apply your changes in `main.js`.
This is the source file that will get transformed into a browser runnable version later.
4. Run `npx browserify main.js -o catalyst_cose.js` to make the module runnable in a browser.
