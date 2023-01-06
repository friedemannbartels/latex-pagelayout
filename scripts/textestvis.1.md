textestvis(1) -- visual regression tests for LaTeX
====

## SYNOPSIS

`textestvis` [-cs] [-e ENGINE] [-d DENSITY] [PATTERN]

`textestvis approve` [-e ENGINE] [PATTERN]

`textestvis compare` [-d DENSITY] FILE FILE

`textestvis perf` [-cs] [-e ENGINE] FILE

## DESCRIPTION

Perform visual regression tests for LaTeX documents.

* `textestvis`:
    Creates PDF files for all tex files matching the pattern and performs a visual regression test. If no pattern is specified, all files in the current directory are tested except for files whose names begin with an underscore.

* `textestvis approve`:
    Replaces the reference files with the test files.

* `textestvis compare`:
    Creates a visual diff for two pdf files.

* `textestvis perf`:
    Measures the time for creating a pdf file from the given tex file.

## OPTIONS

* `-c`:
    Clears cache.
* `-s`:
    Enables shell escape.
* `-d` <DENSITY>:
    Sets density in ppi (default 72).
* `-e` <ENGINE>:
    Sets latex engine (default xelatex).
* `--help`:
    Prints a help message.
* `--version`:
    Prints version information.

## ENVIRONMENT

`textestvis` requires ImageMagick 7.0 or later.

## AUTHOR

`textestvis` was written by Friedemann Bartels. <https://github.com/friedemannbartels>

## LICENSE

Copyright (C) 2023 Friedemann Bartels. Free use of this software is granted under the terms of the LaTeX Project Public License version 1.3c or later.
