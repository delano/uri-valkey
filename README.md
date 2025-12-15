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

## Authentication

### Password-only authentication (most common)

For Valkey/Redis servers using simple password authentication, use a **colon before the password** with an empty username:

```ruby
# Correct format - note the colon before the password
uri = URI.parse 'valkey://:mysecretpassword@localhost:6379/0'
uri.password              # => "mysecretpassword"
uri.conf[:password]       # => "mysecretpassword"
uri.conf                  # => {:host=>"localhost", :port=>6379, :db=>0, :ssl=>false, :password=>"mysecretpassword"}
```

> **⚠️ Common mistake:** Omitting the colon treats the password as a username!
>
> ```ruby
> # WRONG - password is parsed as username, not password!
> uri = URI.parse 'valkey://mysecretpassword@localhost:6379/0'
> uri.user                  # => "mysecretpassword"
> uri.password              # => nil
> uri.conf[:password]       # => nil  # No password will be sent!
> ```

### Username and password authentication (Valkey/Redis 6+ ACLs)

For Valkey or Redis 6+ servers using ACL with username/password:

```ruby
uri = URI.parse 'valkey://myuser:mypassword@localhost:6379/0'
uri.user                  # => "myuser"
uri.password              # => "mypassword"
uri.conf[:password]       # => "mypassword"
```

### Environment variable examples

```bash
# Password-only (most common)
export VALKEY_URL="valkey://:mysecretpassword@localhost:6379/0"
export REDIS_URL="redis://:mysecretpassword@localhost:6379/0"

# Username + password (Valkey/Redis 6+ ACLs)
export VALKEY_URL="valkey://myuser:mypassword@localhost:6379/0"

# No authentication (development only)
export VALKEY_URL="valkey://localhost:6379/0"
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
