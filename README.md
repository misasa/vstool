# gem package -- vstool

A series of `VisualStage 2007` related utilities.  Obtain stage
coordinate from `VisualStage 2007`, transform and export the
image, and attach the image to `VisualStage 2007`.

# Dependency

## [Ruby 2.5, 2.6, or 2.7 for Windows](https://rubyinstaller.org/)

## [gem package -- medusa_rest_client](https://github.com/misasa/medusa_rest_client)

## [gem package -- opencvtool](https://gitlab.misasa.okayama-u.ac.jp/gems/opencvtool)

## [gem package -- visual_stage](https://gitlab.misasa.okayama-u.ac.jp/gems/visual_stage)

## [python package -- image_mosaic](https://github.com/misasa/image_mosaic)

# Installation

    CMD> gem source -a http://dream.misasa.okayama-u.ac.jp/rubygems/
    CMD> gem install vstool
    CMD> vs-attach-image -h

# Commands

Commands are summarized as:

| command              | description                                                        | note |
| -------------------- | ------------------------------------------------------------------ | ---- |
| loop-vs-attach-image | Automatically attach images obtained by SEM to VisualStage 2007    |      |
| vs-add-file          | No description is available                                        |      |
| vs-attach-image      | Copy imagefile to VisualStage 2007                                 |      |
| vs-attach-image-1269 | Copy upper view of Cameca's sample holder to VisualStage 2007      |      |
| vs-attach-image-1270 | Copy upper view of Cameca's sample holder to VisualStage 2007      |      |
| vs-get-affine        | Return current Affine matrix from VisualStage 2007                 |      |

# Usage

See online document:

    $ loop-vs-attach-image --help
    $ vs-add-file --help
    $ vs-attach-image --help
    $ vs-attach-image-1269 --help
    $ vs-attach-image-1270 --help
    $ vs-get-affine --help
