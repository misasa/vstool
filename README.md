# vstool

Provide tools via gem that interact with VisualStage and OpenCV.
Note that [OpenCV](http://opencv.org/) is image manuplating library for Python.

# Dependency

## [opencvtool](http://devel.misasa.okayama-u.ac.jp/gitlab/pythonpackage/opencvtool/tree/master "follow instruction")

## [vs2007](http://devel.misasa.okayama-u.ac.jp/gitlab/pythonpackage/vs2007/tree/master "follow instruction")

# Setup

- Download python 2.7 from https://www.python.org/downloads/ and install it

- Append ;C:\Python27;C:\Python27\Scripts to the %PATH% variable

- Download numpy (numpy-1.9.2-win32-superpack-python2.7.exe) from http://sourceforge.net/projects/numpy/files/NumPy/ and install it

- Download OpenCV (opencv-2.4.11.exe) from http://sourceforge.net/projects/opencvlibrary/files/opencv-win/2.4.11/ and install it into C:\

- Run Command Prompt as Administrator

`

    DOS> copy C:\opencv\build\python\2.7\x86\cv2.pyd C:\Python27\Lib\site-packages
    DOS> pip install git+http://devel.misasa.okayama-u.ac.jp/gitlab/pythonpackage/opencvtool.git
    DOS> Haffine_from_params -h
    DOS> pip install git+http://devel.misasa.okayama-u.ac.jp/gitlab/pythonpackage/vs2007.git
    DOS> vs -h
    DOS> vs start
    DOS> vs-api -h
    DOS> vs-api TEST_CMD
    DOS> gem source -a http://dream.misasa.okayama-u.ac.jp/rubygems/
    DOS> gem install vstool
    DOS> vs-attach-image -h
`

- It also works in CYGWIN

`

    cygwin> gem source -a http://dream.misasa.okayama-u.ac.jp/rubygems/
    cygwin> gem install vstool
    cygwin> vs-attach-image -h
`

# Installation

Add this line to your application's Gemfile:

```ruby
gem 'vstool'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem source -a http://dream.misasa.okayama-u.ac.jp/rubygems/
    $ gem install vstool

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
