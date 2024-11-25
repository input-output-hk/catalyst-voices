import { j0 as Notify_default } from "./index.js";
const resizeImageFile = async (file, maxSize) => {
  const reader = new FileReader();
  const image = new Image();
  const canvas = document.createElement("canvas");
  return new Promise((ok, no) => {
    if (!file.type.match(/image.*/)) {
      Notify_default.create({
        type: "negative",
        message: "File is not an image",
        position: "top-left",
        timeout: 3e3
      });
      return;
    }
    reader.onload = (readerEvent) => {
      image.onload = () => ok(resize(image, maxSize, canvas));
      image.src = readerEvent.target.result;
    };
    reader.readAsDataURL(file);
  });
};
const resizeImage = async (file, maxSize) => {
  const image = new Image();
  const canvas = document.createElement("canvas");
  if (!file.match(/data:image.*/)) {
    Notify_default.create({
      type: "negative",
      message: "File is not an image",
      position: "top-left",
      timeout: 3e3
    });
    return "";
  }
  image.src = file;
  return resize(image, maxSize, canvas);
};
const resize = (image, maxSize, canvas) => {
  let width = image.width;
  let height = image.height;
  if (width > height) {
    if (width > maxSize) {
      height *= maxSize / width;
      width = maxSize;
    }
  } else {
    if (height > maxSize) {
      width *= maxSize / height;
      height = maxSize;
    }
  }
  canvas.width = width;
  canvas.height = height;
  canvas.getContext("2d").drawImage(image, 0, 0, width, height);
  return canvas.toDataURL();
};
export {
  resizeImage as a,
  resizeImageFile as r
};
