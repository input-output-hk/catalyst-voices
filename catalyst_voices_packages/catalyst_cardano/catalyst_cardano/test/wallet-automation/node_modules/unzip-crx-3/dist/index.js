"use strict";

var fs = require("fs");
var path = require("path");
var jszip = require("jszip");
var mkdirp = require("mkdirp");
var promisify = require("yaku/lib/promisify");

var writeFile = promisify(fs.writeFile);
var readFile = promisify(fs.readFile);
var mkdir = promisify(mkdirp);

function crxToZip(buf) {
    function calcLength(a, b, c, d) {
        var length = 0;

        length += a;
        length += b << 8;
        length += c << 16;
        length += d << 24;
        return length;
    }

    // 50 4b 03 04
    // This is actually a zip file
    if (buf[0] === 80 && buf[1] === 75 && buf[2] === 3 && buf[3] === 4) {
        return buf;
    }

    // 43 72 32 34 (Cr24)
    if (buf[0] !== 67 || buf[1] !== 114 || buf[2] !== 50 || buf[3] !== 52) {
        throw new Error("Invalid header: Does not start with Cr24");
    }

    // 02 00 00 00
    // or
    // 03 00 00 00
    var isV3 = buf[4] === 3;
    var isV2 = buf[4] === 2;

    if (!isV2 && !isV3 || buf[5] || buf[6] || buf[7]) {
        throw new Error("Unexpected crx format version number.");
    }

    if (isV2) {
        var publicKeyLength = calcLength(buf[8], buf[9], buf[10], buf[11]);
        var signatureLength = calcLength(buf[12], buf[13], buf[14], buf[15]);

        // 16 = Magic number (4), CRX format version (4), lengths (2x4)
        var _zipStartOffset = 16 + publicKeyLength + signatureLength;

        return buf.slice(_zipStartOffset, buf.length);
    }
    // v3 format has header size and then header
    var headerSize = calcLength(buf[8], buf[9], buf[10], buf[11]);
    var zipStartOffset = 12 + headerSize;

    return buf.slice(zipStartOffset, buf.length);
}

function unzip(crxFilePath, destination) {
    var filePath = path.resolve(crxFilePath);
    var extname = path.extname(crxFilePath);
    var basename = path.basename(crxFilePath, extname);
    var dirname = path.dirname(crxFilePath);

    destination = destination || path.resolve(dirname, basename);
    return readFile(filePath).then(function (buf) {
        return jszip.loadAsync(crxToZip(buf));
    }).then(function (zip) {
        var zipFileKeys = Object.keys(zip.files);

        return Promise.all(zipFileKeys.map(function (filename) {
            var isFile = !zip.files[filename].dir;
            var fullPath = path.join(destination, filename);
            var directory = isFile && path.dirname(fullPath) || fullPath;
            var content = zip.files[filename].async("nodebuffer");

            return mkdir(directory).then(function () {
                return isFile ? content : false;
            }).then(function (data) {
                return data ? writeFile(fullPath, data) : true;
            });
        }));
    });
}

module.exports = unzip;