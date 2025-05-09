# SVGO Test Suite [![](https://img.shields.io/discord/815166721315831868)](https://discord.gg/z8jX8NYxrE)

Scripts for building a test suite of SVGs from multiple sources. The aim is to maintain an archive that's convenient and relatively efficient to pull from CI pipelines to run regression tests.

The contents of the archive will be optimized for the pull request pipelines of SVGO, and may be prone to breaking changes without notice.

## Sources

SVGO Test Suite includes files from the following sources. We use [REUSE](https://reuse.software/) to annotate each file with the respective license, attribution, and copyright information within the distributed archive.

* [W3C SVG 1.1 Test Suite](https://www.w3.org/Graphics/SVG/Test/20110816/)
* [KDE Oxygen Icons](https://download.kde.org/stable/frameworks/5.116/oxygen-icons-5.116.0.tar.xz.mirrorlist)
* [Wikimedia Commons](https://commons.wikimedia.org/wiki/Category:Large_SVG_files)

## Processing

Here are the differences between the repack and the original SVGs:

* Exclude symlinks.
* Convert SVGZ files to SVGs.
* Exclude non-SVG files.
* Convert UTF16-LE encoded files to UTF-8.
* Delete duplicate files.
* Rename files to have sensible file names. i.e. `(file)+.svg` → `_file__.svg`

## SVG Optimizer

If you're looking for the library and CLI application to optimize SVGs, see [SVGO](https://github.com/svg/svgo).
