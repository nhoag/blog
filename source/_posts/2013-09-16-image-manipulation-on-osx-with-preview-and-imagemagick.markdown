---
layout: post
title: "Image Manipulation on OSX with Preview and ImageMagick"
date: 2013-09-16 22:05
comments: true
categories: 
- ImageMagick
- Preview
- OSX
- opacity
---
I recently modified the Google profile image on my work Google+ account to make it more clear that it's a work profile rather than a personal profile. I added a few layers to my existing profile image including a work logo and a couple of simple transparencies. In the past I would have relied on Photoshop, GIMP, or another heavy image manipulation GUI software to accomplish this task. This time around, I decided to make use of the OSX Preview program in conjunction with the command line tool, ImageMagick.

To get ImageMagick running on OSX is as simple as running `brew install imagemagick` with Homebrew. This gives you tons of image manipulation powers that are described under the command `man convert`.

Preview is pretty much a terrible image editing interface. But with patience you can use it to minimally mash up several layers of images. To start, I had a profile JPG image, and a logo PNG file. To add to the mix I created a couple of lightly shaded transparencies to encapsulate the logo. Following are a set of commands to generate a simple shaded transparency.

Generate a black rectangle:
``` bash New Black Rectangle
convert -size 20x80 xc:black black.jpg
```

Add transparency to the black rectangle:
``` bash Add Transparency
convert black.jpg -alpha on -channel alpha -evaluate set 25% black-25.png
```

Add more transparency:
``` bash More Transparency
convert black-25.jpg -alpha on -channel alpha -evaluate set 50% black-12.5.png
```

Now to mash the images together, open them all up in Preview, 'select all' for an image you want to overlay on the profile, paste the image into the profile, then resize and/or re-orient the overlay image dimensions as desired.
