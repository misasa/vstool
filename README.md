# gem package -- vstool

A series of `VisualStage 2007` related utilities.  Obtain stage
coordinate from `VisualStage 2007`, convert the image to fit to the
coordinate, and attach the image to `VisualStage 2007`.


# Dependency

## [python package -- ImageMosaic](https://github.com/misasa/image_mosaic "follow instruction")

## [python package -- vs2007](https://gitlab.misasa.okayama-u.ac.jp/pythonpackage/vs2007/tree/master "follow instruction")

# Installation

- Install this gem package.

`

    CMD> gem source -a http://dream.misasa.okayama-u.ac.jp/rubygems/
    CMD> gem install vstool
    CMD> vs-attach-image -h
`

# Commands

Commands are summarized as:

| command              | description                                                          | note |
| -------------------- | -------------------------------------------------------------------- | ---- |
| loop-vs-attach-image | Keep attaching image to VisualStage                                  |      |
| vs-add-file          | No description is available                                          |      |
| vs-attach-image      | Upload image to VisualStage 2007                                     |      |
| vs-attach-image-1269 | Upload upper view of Cameca's sample holder to VisualStage 2007      |      |
| vs-attach-image-1270 | Upload upper view of Cameca's sample holder to VisualStage 2007      |      |
| vs-get-affine        | Return current Affine matrix from VisualStage 2007                   |      |

# Usage

See online document:

    $ loop-vs-attach-image --help
    $ vs-add-file --help
    $ vs-attach-image --help
    $ vs-attach-image-1269 --help
    $ vs-attach-image-1270 --help
    $ vs-get-affine --help

# Contributing

1. Fork it ( https://github.com/[my-github-username]/vstool/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
