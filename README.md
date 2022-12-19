# Xput

__Declarative Desktop Publishing with LaTeX__

The Xput LaTeX class provides a collection of macros that wrap the macro put to offer a more desktop-publishing-like experience for creating graphic rich documents like photo books.
With Xput you can create single- and double-sided documents, create pages with margins, safety margins and bleed, use templates, align text and graphics in a grid, wrap text across multiple pages and use before pages. 
Generic templates, automatic grid layout and a simple and consistent user interface make it easier than ever to create graphic rich documents with LaTeX.
Under the hood Xput uses the TikZ and tcolorbox packages, ImageMagick and Inkscape.

Xput is distributed under the [LaTeX Project Public License](https://www.latex-project.org/lppl/lppl-1-3c/) version 1.3c or later.

To submit bug reports and feature requests go to the official repository on [GitHub](https://github.com/friedemannbartels/xput/issues).

## Installation

In general, you should use the package manager shipped with your TeX distribution to install Xput. Alternatively you can copy the contents of [xput-1.0.1.tds.zip](https://github.com/friedemannbartels/xput/releases/download/1.0.1/xput-1.0.1.tds.zip) to your local TeX directory tree.

### Command Line Tools

For image optimization, shadow creation and preflight perform these installation steps:

- Add the directory `tex/latex/xput/scripts` in your local TeX file tree to your `$PATH`.
- Add `xputserver` to the list of `shell_escape_commands` in your `texmf.cnf`.
- Install ImageMagick 7.0 or newer and Inkscape 1.0 or newer.

The setup is tested with the engines `xelatex`, `pdflatex` and `lualatex` and the shells `zsh`, `bash` and `dash`.

## Known Issues

### LuaLaTeX

Setting the page width and height as document option or in the preamble does not work with LuaLaTeX. You need to set the page width and height after `begin{document}`.
Multi-threaded batch processing of images does not work with LuaLaTeX too.

### LuaLaTeX and pdfLaTeX

LuaLaTeX and pdfLaTeX only work with restricted shell access. When running with unrestricted shell access (`--shell-escape`), image optimization, shadow creation and preflight do not work.

## Development

Run visual regression tests with the following command:

    cd test
    xput test
    
The tests are not included in the [CTAN](https://www.ctan.org/pkg/xput) package. You find the tests on [GitHub](https://github.com/friedemannbartels/xput/tree/main/test).
