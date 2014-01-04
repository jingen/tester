#!/usr/bin/env ruby

require "rmagick"
source = Magick::Image.read("rmagick.png").first #read will return array containing 0 or more Image objects. If the file is a multi-image file such as an animated GIF or a Photoshop PSD file with multiple layers, the array contains an Image object for each image or layer in the file.
source = source.resize_to_fill(200,200).quantize(256, Magick::GRAYColorspace).contrast(true)
overlay = Magick::Image.read("overlay.png").first
source.composite!(overlay, 0, 0, Magick::OverCompositeOp)
colored = Magick::Image.new(200,200) {self.background_color="red"}
colored.composite!(source.negate, 0, 0, Magick::CopyOpacityCompositeOp)
colored.write("rmagick_result.png")

