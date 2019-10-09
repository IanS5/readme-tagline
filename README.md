# readme-tagline.sh

readme-tagline.sh is a simple script to grab the first sentence from a readme file.

## Usage

`readme-tagline.sh path/to/project-or-readme`

If the supplied path is a directory, readme-tagline will search for a file named `readme.<any-extension>` (case insensitive).

## How

readme-tagline uses [pandoc](https://pandoc.org/) to convert the readme to HTML. Then uses `sed` to grab the first sentence from the first paragraph in the readme.

## Required Applications

The only applications used outside of coreutils are `pandoc` and `sed`.
`sed` ships with most systems.
`pandoc` is less likely to be installed; However it is available on most package managers.
See [_Installing Pandoc_](https://pandoc.org/installing.html) for details.

List of applications with tested versions:

- ls (tested: GNU coreutils 8.28, 8.30)
- head (tested: GNU coreutils 8.28. 8.30)
- tr (tested: GNU coreutils 8.28, 8.30)
- sed (tested: GNU sed 4.4, 4.7)
- pandoc (tested: pandoc 1.19.2.4, 2.2.1)

## Shells

readme-tagline will run on any POSIX compliant shell.
It has been tested on the following shells:

- ksh 2012-08-01
- bash 4.4, 5.0.3
- dash 0.5.8, 0.5.10
- ash 0.5.8, busybox v1.27.2
- zsh 5.4.2, 5.7.1
