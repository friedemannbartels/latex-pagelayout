## What is Xput

Xput is a LaTeX class to layout graphic rich, perfectly typeset, and print ready PDFs. It provides simple macros to put content on a page declaratively. Generic and custom templates, automatic grid layout, and a simple and consistent user interface help you to create layouts with ease.

The integration of [Inkscape](https://inkscape.org) allows your to create box shadows. Text shadows and SVG filters are ideas for future releases.

The integration of [ImageMagick](https://imagemagick.org) allows you to configure compression and sharpening for bitmap graphics to export web, print or preview versions of your document. Parallelized image optimization, caching, and a draft mode enable fast PDF creation and a responsive workflow, even for large documents with lots of photos and graphics.

Xput also integrates the [TikZ](https://www.ctan.org/pkg/pgf) and [tcolorbox](https://www.ctan.org/pkg/tcolorbox) LaTeX packages.

## Quick Start

### Generic Templates

Generic templates are the easiest way to put content on a page. The template name describes the layout. You can arrange [l]andscape, [p]ortrait, [s]quare, [w]ide, [g]olden ratio, g[o]lden upright ratio or [f]lexible placeholders in rows [-]. A valid template name for example is `sg-ff`. Notice you cannot combine flexible with fixed aspect ratio placeholders within a row.

```latex
\template{ss}{
  \text{
    This text fills the first placeholder.
  }
}
```

![Generic template](doc/quickstart-1.svg)

### Custom Templates

You can use the grid to layout content on a page. The grid has rows with cells. You can set width relations between cells and height relations between rows. You can give cells a explicit aspect ratio by adding a `!`.

```latex
\newtemplate{my template}{
  \setgrid{
    {[2]{3!}{2!}}
  }
  \placeholder{0 0 1 1}
}

\template{my template}{}
```

![Custom template](doc/quickstart-2.svg)

You can set margin and gutter for a single grid, on document level, or on page level.

### Graphics

You can scale and position a graphic. And you can add borders and box shadows to graphics and text frames.

```latex
\newborder{my border}{width=2mm, color=white, radius=5mm}
\newshadow{my shadow}{size=8}

\template[margin=7mm]{s}{
  \graphic[
    scale=1.1,
    hpos=0.2,
    unsharp=3x1,
    shadow=my shadow,
    border=my border,
    border radius=0mm
  ]{kopi}
}
```

![Photo with border and shadow](doc/quickstart-3.svg)

Have a look at the [examples](doc) to learn how to create double pages, cover pages, and more.

For a complete reference, read the [manual](doc/xputmanual.pdf).

## Installation

In general, you should use the package manager shipped with your TeX distribution to install Xput.

To install Xput manually, copy the contents of [xput.tds.zip](https://github.com/friedemannbartels/xput/releases/download/v1.0.2/xput.tds.zip) to your local TeX directory tree and run the command `texhash`.

To enable image optimization, shadow creation, and preflight, perform these installation steps:

- Make sure that ImageMagick 7.0 or later and Inkscape 1.0 or later are installed.

- Find your top level _texmf.cnf_ with the command `kpsewhich texmf.cnf`, and add `xputserver` to the list of `shell_escape_commands`.
  ```
  shell_escape_commands = xputserver
  ```
- When installing manually, add the directory _scripts/xput_ to your `PATH`.

## Development

Run visual regression tests inside the _tests_ directory with the command `textestvis`.
