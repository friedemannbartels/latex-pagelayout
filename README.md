## What is Xput

Xput is a LaTeX class to create graphic rich, layouted, perfectly typeset, and print ready PDFs just from a text file. It provides simple macros to put content on a page declaratively. Generic templates, automatic grid layout, and a simple and consistent user interface help you to create layouts with ease.

The integration of Inkscape allows your to create beautiful box shadows. Text shadows and SVG filters are ideas for future releases.

The integration of ImageMagick allows you to configure the PDF export to create web, print or preview versions of your document. Parallelized image optimization, caching and a draft mode enable fast PDF creation and a responsive workflow, even for large documents with lots of photos and graphics.

Xput also integrates the TikZ and tcolorbox LaTeX packages.

## Quick Start

### Generic Templates

Generic templates are the easiest way to put content on a page. The template name describes the layout. You can arrange [l]andscape, [p]ortrait, [s]quare, [w]ide, [g]olden ratio, g[o]lden upright ratio or [f]lexible placeholders in rows [-]. A valid template name for example is `sg-ff`. Notice you cannot combine flexible with fixed aspect ratio placeholders within a row.

```latex
\template{sg}{
  \text{Hello Xput}
  \graphic{IMG1234}
}
```

### Custom Templates and the Grid

You can use the grid to layout content on a page. The grid has rows with cells. You can set width relations between cells and height relations between rows. You can give cells a explicit aspect ratio by adding a `!`.

```latex
\newtemplate{my template}{
  \grid{
    {[2]{2!}{3!}}
    {[2]{1}}
  }
  \placeholder{0 0 1 1}
}
```

You can set margin and gutter for a single grid or on document or page level.

### Graphics

Adding a graphic to a page is simple. You can scale, position and sharpen a graphic.

```latex
\page{
  \graphic[
    scale=1.2,
    hpos=0.3,
    unsharp=3x1
  ]{filename}
}
```

### Borders and Shadows

You can add borders and box shadows to graphics and text frames.

```latex
\newborder{my border}{
  width=2mm,
  color=magenta,
  radius=5mm
}
\newshadow{my shadow}{
  size=5,
  color=magenta,
  opacity=1
}

\page{
  \graphic[
    shadow=my shadow,
    border=my border,
    border radius=10mm
  ]{filename}
}
```

Have a look at the [examples](https://github.com/friedemannbartels/xput/tree/main/doc) and start playing with these.

For a complete reference have a look at the [manual](https://github.com/friedemannbartels/xput/raw/main/doc/xputmanual.pdf).

## Installation

In general, you should use the package manager shipped with your TeX distribution to install Xput. Alternatively you can copy the contents of [xput.tds.zip](https://github.com/friedemannbartels/xput/releases/download/v1.0.2/xput.tds.zip) to your local TeX directory tree.

### Command Line Tools

For image optimization, shadow creation and preflight perform these installation steps:

- Add the directory _tex/latex/xput/scripts_ in your local TeX file tree to your `$PATH`.

- Add `xputserver` to the list of `shell_escape_commands` in your top level _texmf.cnf_.  Find your _texmf.cnf_ with the command `kpsewhich texmf.cnf`.

- Install ImageMagick 7.0 or newer and Inkscape 1.0 or newer.

## Development

Run visual regression tests inside the _tests_ directory with the command `xput test`
