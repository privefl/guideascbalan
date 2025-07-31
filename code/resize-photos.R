# ou aller sur https://redketchup.io/image-resizer
path <- "../../../Downloads/florian_privé.jpg"
(im <- magick::image_read(path))
(new_im <- pixelart::crop(im, bottom = 120, left = 460, right = 370))
(new_im <- pixelart::crop(im, top = 15))
# aim for 3/4 ratio
# magick::image_write(new_im, path)
