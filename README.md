# Vstool

Provide tools via gem that interact with VisualStage and OpenCV.
Note that [OpenCV](http://opencv.org/) is image manuplating library for Python.

## Dependency

### [opencvtool](http://devel.misasa.okayama-u.ac.jp/gitlab/pythonpackage/opencvtool/tree/master "follow instruction")

### [vs2007](http://devel.misasa.okayama-u.ac.jp/gitlab/pythonpackage/vs2007/tree/master "follow instruction")


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vstool'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem source -a http://dream.misasa.okayama-u.ac.jp/rubygems
    $ gem install vstool

## Commands

Commands are summarized as:

| command              | description                                                          | note |
| -------------------- | -------------------------------------------------------------------- | ---- |
| loop-vs-attach-image | Keep attach image to VisualStage                                     |      |
| vs-add-file          | No description is available                                          |      |
| vs-attach-image      | Attach image to VisualStage 2007                                     |      |
| vs-attach-image-1269 | Attach upper view of Cameca's sample holder to VisualStage 2007      |      |
| vs-attach-image-1270 | Attach upper view of Cameca's sample holder to VisualStage 2007      |      |
| vs-get-affine        | Obtain current Affine matrix from VisualStage 2007                   |      |

## Usage

See online document:

    $ loop-vs-attach-image --help
    $ vs-add-file --help
    $ vs-attach-image --help
    $ vs-attach-image-1269 --help
    $ vs-attach-image-1270 --help
    $ vs-get-affine --help

## Contributing

1. Fork it ( https://github.com/[my-github-username]/vstool/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request