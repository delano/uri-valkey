# URI-Valkey

Creates URI objects for Valkey URLs, with support for parsing connection strings and extracting configuration parameters.

## Supported URI Formats

    valkey://host:port/dbindex
    valkeys://host:port/dbindex   # SSL
    redis://host:port/dbindex     # Cross-scheme compatibility
    rediss://host:port/dbindex    # Cross-scheme compatibility (SSL)

## Installation

* `gem install uri-valkey`
* `git clone git@github.com:delano/uri-valkey.git`

## Usage

```ruby
require 'uri-valkey'  # or require 'uri_valkey'

conf = URI.parse 'valkey://localhost:6379/0'
conf.scheme               # => "valkey"
conf.host                 # => "localhost"
conf.port                 # => 6379
conf.db                   # => 0
conf.to_s                 # => "valkey://localhost:6379/0"

# Access configuration hash
conf.conf                 # => {:host=>"localhost", :port=>6379, :db=>0, :ssl=>false}
```

### SSL Support

SSL is supported by using the `valkeys` scheme:

```ruby
conf = URI.parse 'valkeys://localhost:6379/0'
conf.scheme               # => "valkeys"
conf.conf[:ssl]           # => true
```

### Working with Keys

The URI class supports parsing and manipulating Valkey keys:

```ruby
uri = URI.parse 'valkey://localhost:6379/2/mykey:namespace'
uri.db                    # => 2
uri.key                   # => "mykey:namespace"

# Modify the key
uri.key = 'newkey:value'
uri.to_s                  # => "valkey://localhost:6379/2/newkey:value"

# Modify the database
uri.db = 5
uri.to_s                  # => "valkey://localhost:6379/5/newkey:value"
```

### Building URIs

```ruby
uri = URI::Valkey.build(host: "localhost", port: 6379, db: 2, key: "v1:arbitrary:key")
uri.to_s                  # => "valkey://localhost:6379/2/v1:arbitrary:key"
```

### Query Parameters

Query parameters are supported for additional configuration:

```ruby
uri = URI.parse "valkey://127.0.0.1/6/?timeout=5&retries=3"
uri.conf                  # => {:db=>6, :timeout=>5, :retries=>"3", :host=>"127.0.0.1", :port=>6379, :ssl=>false}
```

## Cross-Scheme Compatibility

Both gems support each other's URL schemes for maximum flexibility:

```ruby
# Valkey gem can parse Redis URLs
redis_uri = URI.parse 'redis://localhost:6379/0'
redis_uri.scheme          # => "redis"
redis_uri.conf            # => {:host=>"localhost", :port=>6379, :db=>0, :ssl=>false}

# SSL schemes work cross-platform
ssl_uri = URI.parse 'rediss://localhost:6379/0'
ssl_uri.conf[:ssl]        # => true
```

## URI-Redis

A `uri-redis` gem is also available with identical functionality for Redis URLs, including support for `valkey://` and `valkeys://` schemes:

```ruby
require 'uri-redis'

conf = URI.parse 'redis://localhost:6379/0'
conf.scheme               # => "redis"
conf.conf                 # => {:host=>"localhost", :port=>6379, :db=>0, :ssl=>false}
```

### Redis Client Integration

If you have the `redis` gem installed, URI-Redis provides a refinement to add URI support directly to Redis client instances:

```ruby
require 'uri-redis'

# Enable the refinement in your scope
using RedisURIRefinement

redis = Redis.new(url: 'redis://localhost:6379/2')
redis.uri                 # Returns URI object for the Redis client's connection

# Class method for generating URIs from configuration
Redis.uri(host: 'localhost', port: 6379, db: 2, ssl: true)
# => URI object for "rediss://localhost:6379/2"
```

**Note:** The refinement is only available when the `redis` gem is loaded and only works within scopes where `using RedisURIRefinement` has been called.

## About

* [Github](https://github.com/delano/uri-valkey)

## License

See LICENSE.txt
