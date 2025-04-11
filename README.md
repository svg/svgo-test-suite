# SVGO Test Suite [![chat](https://img.shields.io/discord/815166721315831868)](https://discord.gg/z8jX8NYxrE)

Scripts for building a test suite of SVGs from multiple sources. The aim is to maintain an archive that's convenient and relatively efficient to pull from CI pipelines to run regression tests.

The contents of the archive will be optimized for the pull request pipelines of SVGO, and may be prone to breaking changes without notice.

## Sources

| Source | License |
|---|---|
| [W3C SVG 1.1 Test Suite](https://www.w3.org/Graphics/SVG/Test/20110816/) | [W3C test suite license](https://www.w3.org/copyright/test-suite-license-2023) |
| [KDE Oxygen Icons](https://download.kde.org/stable/frameworks/5.116/oxygen-icons-5.116.0.tar.xz.mirrorlist) | [LGPL-3.0](https://invent.kde.org/frameworks/oxygen-icons/-/blob/master/COPYING) |

## Processing

Here are the differences between the repack and the originals:

* Excludes symlinks.
* Excludes non-SVG files.
* Converts SVGZ files to SVGs.
* Converts UTF16-LE encoded files to UTF-8.
* Deletes duplicate files.

## SVG Optimizer

If you're looking for the library and CLI application to optimize SVGs, see [SVGO](https://github.com/svg/svgo).
