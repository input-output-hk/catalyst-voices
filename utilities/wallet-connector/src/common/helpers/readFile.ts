type ReadAs = "buffer" | "data-url" | "text";

export default function readFile(blob: Blob, readAs: ReadAs): Promise<string | ArrayBuffer | null> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();

    reader.onabort = () => reject(Error("file reading was aborted"));
    reader.onerror = () => reject(Error("file reading has failed"));
    reader.onload = () => resolve(reader.result);

    if (readAs === "buffer") {
      reader.readAsArrayBuffer(blob);
    } else if (readAs === "data-url") {
      reader.readAsDataURL(blob);
    } else if (readAs === "text") {
      reader.readAsText(blob);
    } else {
      reject(Error("invalid reading scheme"));
    }
  });
}
