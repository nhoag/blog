---
comments: true
date: 2013-09-18T00:00:00Z
tags:
- imagemagick
- composite
- convert
- overlay
- transparency
- opacity
title: Let's Skip Preview and Just Use ImageMagick
url: /blog/2013/09/18/lets-skip-preview-and-just-use-imagemagick/
---

Same problem, one tool... (this would be a great time to set up an S3 media bucket to show results). In addition to [ImageMagick](http://www.imagemagick.org/script/index.php), I installed ghostscript with `brew install ghostscript` to enable working with eps vector images.

Starting with a square profile photo:

```
identify nhoag-bw-sq.jpg
/path/to/nhoag-bw-sq.jpg JPEG 480x480 480x480+0+0 8-bit sRGB 65.5KB 0.000u 0:00.000
```

Generate a black rectangle to match the width of the profile photo:

```
convert -size 480x100 xc:black black.jpg
```

Reduce the opacity of the new rectangle:

```
convert black.jpg -alpha on -channel alpha -evaluate set 25% shade-25.png
```

Overlay the modified rectangle on the photo:

```
composite -gravity center shade-25.png nhoag-bw-sq.jpg nhoag-shade.jpg
```

Convert black text eps file to png:

```
convert -colorspace RGB -density 300 black_text.eps -resize x95 black_text.png
```

Reduce the opacity of the black text png:

```
convert black_text.png +flatten -alpha on -channel A -evaluate set 10% +channel black_text_opac.png
```

Create a slightly larger canvas for the black text png (to accommodate blur):

```
convert -size 475x110 xc:transparent black_text_canvas.png
```

Overlay the black text png on the new canvas:

```
composite -gravity center black_text_opac.png black_text_canvas.png black_text_opac_canvas.png
```

Blur the black text png:

```
convert black_text_opac_canvas.png -blur 0x4 black_text_opac_canvas_blur.png
```

Overlay the black text png on the profile photo:

```
composite -gravity center black_text_opac_canvas_blur.png nhoag-shade.jpg nhoag-shade-black_text.jpg
```

Convert white text eps file to png:

```
convert -colorspace RGB -density 300 white_text.eps -resize x95 white_text.png
```

Overlay white text png on the profile photo:

```
composite -gravity center white_text.png nhoag-shade-black_text.jpg nhoag-shade-black_text-white_text.jpg
```

Generate a new png with the text 'profile':

```
montage -background none -fill white -font Courier \
	-pointsize 72 label:'Profile' +set label \
	-shadow  -background transparent -geometry +5+5 \
	profile_text.png
```

Overlay the 'profile' text on the profile photo:

```
composite -gravity center -geometry +0+90 profile_text.png nhoag-shade-black_text-white_text.jpg nhoag-shade-black_text-white_text-profile.jpg
```

You can view the finished product on my [Acquia Google+ profile](https://plus.google.com/u/0/photos/111618742025061693733/albums/profile/5925122293096024242?pid=5925122293096024242&oid=111618742025061693733).
