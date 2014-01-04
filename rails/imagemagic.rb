imagemagick.org
brew install imagemagick
brew install libmagic
convert -version
(cmd for processing the images)

Geometry Options:
size	General description (actual behavior can vary for different options and settings)
scale%	Height and width both scaled by specified percentage.
scale-x%xscale-y%	Height and width individually scaled by specified percentages. (Only one % symbol needed.)
width	Width given, height automagically selected to preserve aspect ratio.
xheight	Height given, width automagically selected to preserve aspect ratio.
widthxheight	Maximum values of height and width given, aspect ratio preserved.
widthxheight^	Minimum values of width and height given, aspect ratio preserved.
widthxheight!	Width and height emphatically given, original aspect ratio ignored.
widthxheight>	Shrinks an image with dimension(s) larger than the corresponding width and/or height argument(s).
widthxheight<	Enlarges an image with dimension(s) smaller than the corresponding width and/or height argument(s).
area@	Resize image to have specified area in pixels. Aspect ratio is preserved.

convert Sad.png -resize '70x70^' -crop '70x70+0+0' sad_convert.png
convert Sad.png -resize '700x700^' -crop '700x700+0+0' sad_convert.png
convert Sad.png -resize '70x100^' -gravity center -crop '70x100+0+0' sad_convert.png
convert Sad.png -resize '200x200^' -gravity center -crop '200x200+0+0' -quantize GRAY -colors 256 sad_convert.png
convert Sad.png -resize '200x200^' -gravity center -crop '200x200+0+0' -quantize GRAY -colors 256 -contrast sad_convert.png
(-contrast: enhance)


-resize geometry
Resize an image.

-crop geometry{@}{!}
Cut out one or more rectangular regions of the image.

-gravity type
Sets the current gravity suggestion for various other settings and options.	

-quantize colorspace
reduce colors using this colorspace.

-colors value
Set the preferred number of colors in the image.

-contrast
Enhance or reduce the image contrast.

-compose operator

-composite
Perform alpha composition on two images and an optional mask

composite:
Use the composite program to overlap one image over another. See Command Line Processing for advice on how to structure your composite command or see below for example usages of the command.

composite sad_convert.png oa_overlap.png new.png (sad_convert.png is on the top of oa_overlap.png)

convert -size 200x200 canvas:red color.png

convert -size 200x200 canvas:red sad_convert.png -compose copy-opacity -composite stamp.png

convert -size 200x200 canvas:red \( sad_convert.png -negate \) -compose copy-opacity -composite stamp.png
(invert image color)

final version of command:
  convert -size 70x70 canvas:red \( original.png -resize '70x70^' -gravity center -crop '70x70+0+0' -gravity center -crop '70x70+0+0' -quantize GRAY -colors 256 -contrast stamp_overlay.png -composite -negate \) -compose copy-opacity -composite stamp.png

Gems:
  1. image_sorcery
  2. mini_magick
* 3. rmagick

gem install rmagick

(resize) : no constrain.
(resize_to_fit) : based on the original ratio, no croped.
(resize_to_fill) : based on the original ratio, croped if necessary.

