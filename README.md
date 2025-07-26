# URI-Valkey

Creates a URI object for Valkey URLs.

e.g.

    valkey://host:port/dbindex

## Usage

```ruby
    require 'uri/valkey'

    conf = URI.parse 'valkey://localhost:6379/0'
    conf.scheme               # => "valkey"
    conf.host                 # => localhost
    conf.port                 # => 6379
    conf.db                   # => 0
    conf.to_s                 # => valkey://localhost:6379/0
```

### SSL Support

SSL is supported by using the `valkeys` scheme.

```ruby
    require 'uri/valkey'

    conf = URI.parse 'valkeys://localhost:6379/0'
    conf.scheme               # => "valkeys"
    conf.to_s                 # => valkeys://localhost:6379/0
```


## Installation

Get it in one of the following ways:

* `gem install uri-valkey`
* `git clone git@github.com:delano/uri-valkey.git`


## About

* [Github](https://github.com/delano/uri-valkey)


## License

See LICENSE.txt
