path <- "photos/jean-jacques_berrard.png"
(im <- magick::image_read(path))
(new_im <- pixelart::crop(im, left = 7, right = 7))
(new_im <- pixelart::crop(im, top = 15))
# magick::image_write(new_im, path)
