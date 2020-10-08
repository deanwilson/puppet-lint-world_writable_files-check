# puppet-lint world_writable_files check

A puppet-lint extension that ensures file resources do not have a mode
that makes them world writable.

[![Build Status](https://travis-ci.org/deanwilson/puppet-lint-world_writable_files-check.svg?branch=main)](https://travis-ci.org/deanwilson/puppet-lint-world_writable_files-check)

On a *nix system a world writable file is one that anyone can write to.
This is often undesirable, especially in production, where who can
write to certain files should be limited and enabled with deliberation,
not by accident.

This plugin currently only checks octal file modes, the
[no_symbolic_file_modes](https://github.com/deanwilson/puppet-lint-no_symbolic_file_modes-check)
`puppet-lint` check ensure this isn't a problem for my code bases but it
might be a consideration for other peoples usages.

## Installation

To use this plugin add the following line to your `Gemfile`

    gem 'puppet-lint-world_writable_files-check'

and then run `bundle install`

## Usage

This plugin provides a new check to `puppet-lint` that warns if it finds
a file resource that would be created with a mode that allowed every one
to write to it.

    class locked_down_file {
      file { '/tmp/open_octal':
        ensure => 'file',
        mode   => '0666',
      }
    }

This example makes a file that can be read and written to by all users
of the system and so will raise:

    files should not be created with world writable permissions

## Other puppet-lint plugins

You can find a list of my `puppet-lint` plugins in the
[unixdaemon puppet-lint-plugins](https://github.com/deanwilson/unixdaemon-puppet-lint-plugins) repo.

### Author
[Dean Wilson](http://www.unixdaemon.net)
