pagelayoutapi(1) -- API for the pagelayout LaTeX class
====

## SYNOPSIS

`pagelayoutapi getwidth` % FILE

`pagelayoutapi optimize` % FILE % FILENAME % EXTENSION % ORIGINALWIDTH % ORIGINALHEIGHT % CROPLEFT % CROPRIGHT % CROPTOP % CROPBOTTOM % DENSITY % WIDTH % HEIGHT % DOWNSAMPLETHRESHOLD % UNSHARP % QUALITY

`pagelayoutapi makeshadow` % FILENAME % STANDARDDEVIATION % OPACITY % COLOR % WIDTH % HEIGHT % FRAMEWIDTH % FRAMEHEIGHT % MARGIN % BORDERRADIUS

`pagelayoutapi start` [% import % [GRAPHICSPATH]] [% turbo % JOBNAME]

`pagelayoutapi batchoptimize` % BATCHLIST

## DESCRIPTION

This script provides an API for the pagelayout LaTeX class.

* `pagelayoutapi getwidth`:
    Returns the width in pixels for the given image file.

* `pagelayoutapi optimize`:
    Creates a cropped, rezised, sharpend and compressed image and stores it in the cache directory.

* `pagelayoutapi makeshadow`:
    Creates a shadow image and stores it in the cache directory.

* `pagelayoutapi start`:
    The import parameter triggers the image import (see pagelayout-manual.pdf chapter "Image Optimization").
    Running the command with the parameter turbo, where the jobname is the filename of the document, processes the document in a special batch mode, that creates a batch list and calls the command `pagelayoutapi batchoptimize`.

* `pagelayoutapi batchoptimize`:
    Optimizes multiple images in parallel.

## OPTIONS

* `--help`:
    Prints a help message.
* `--version`:
    Prints version information.

## PARAMETERS

* FILE:
     filename with extension (eg. IMG1234.JPEG)
* FILENAME:
     filename without extension (eg. IMG1234)
* EXTENSION:
     optimized file extension (.jpg|.png)
* DENSITY:
     density in ppi (eg. 72)
* DOWNSAMPLETHRESHOLD:
     downsample threshold (integer >= 100)
* UNSHARP:
     unsharp filter (eg. 2x1)
* QUALITY:
     quality (integer > 0, <= 100)
* STANDARDDEVIATION:
     standard deviation (decimal > 0.0)
* OPACITY:
     opacity (decimal >= 0.0, <= 1.0)
* COLOR:
     color string (eg. pink)
* GRAPHICSPATH:
     list of directories (eg. {images/}{tmp/})
* JOBNAME:
     LaTeX filename without extension (eg. my-document)
* BATCHLIST:
     a flat list of batch items where each batch item is a flat list of the 15 parameters required by the command \`pagelayoutapi optimize\`

All other parameters are length dimensions. The command `pagelayoutapi optimize` expects integer values in the LaTeX unit sp (eg. 65536). The command `pagelayoutapi makeshadow` expects decimal values in a SVG compatible unit (eg. 420.0pt).

## ENVIRONMENT

`pagelayoutapi` requires ImageMagick 7.0 or later and Inkscape 1.0 or later.

* `PAGELAYOUT_IMPORT_DIRECTORY`:
    Defines a system wide import directory.

## AUTHOR

`pagelayoutapi` was written by Friedemann Bartels. <https://github.com/friedemannbartels>

## LICENSE

Copyright (c) 2022-2023 Friedemann Bartels. Free use of this software is granted under the terms of the LaTeX Project Public License version 1.3c or later.
