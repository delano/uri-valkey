# frozen_string_literal: true

require 'uri'
require 'uri/generic'

module URI
  # Shared module for Valkey-compatible database URI classes (Redis, Valkey, etc.)
  # Provides common functionality for handling database URIs with database indices and key paths
  module PerfectStrangers
    DEFAULT_PORT = 6379
    DEFAULT_DB = 0

    def self.included(base)
      base.extend(ClassMethods)
    end

    # Class methods for database URI classes
    module ClassMethods
      def build(args)
        tmp = Util.make_components_hash(self, args)
        super(tmp)
      end
    end

    def request_uri
      path_query
    end

    def key
      return if path.nil?

      self.path ||= "/#{DEFAULT_DB}"
      (self.path.split('/')[2..] || []).join('/')
    end

    def key=(val)
      self.path = if val && !val.to_s.empty?
                    "/#{db}/#{val}"
                  else
                    "/#{db}"
                  end
    end

    def db
      self.path ||= "/#{DEFAULT_DB}"
      (self.path.split('/')[1] || DEFAULT_DB).to_i
    end

    def db=(val)
      current_key = key
      self.path = if current_key && !current_key.empty?
                    "/#{val}/#{current_key}"
                  else
                    "/#{val}"
                  end
    end

    def conf
      hsh = {
        host: host,
        port: port,
        db: db,
        ssl: ssl_schemes.include?(scheme)
      }.merge(parse_query(query))
      hsh[:password] = password if password
      hsh[:timeout] = hsh[:timeout].to_i if hsh.key?(:timeout)
      hsh
    end

    def serverid
      format('%s://%s:%s/%s', scheme, host, port, db)
    end

    private

    # Override in including classes to define which schemes use SSL
    def ssl_schemes
      raise NotImplementedError, 'ssl_schemes must be implemented in including classes'
    end

    # Based on: https://github.com/chneukirchen/rack/blob/master/lib/rack/utils.rb
    # which was originally based on Mongrel
    def parse_query(query, delim = nil)
      delim ||= '&;'
      params = {}
      (query || '').split(/[#{delim}] */n).each do |p|
        k, v = p.split('=', 2).map { |str| str } # NOTE: uri_unescape
        k = k.to_sym
        if (cur = params[k])
          if cur.instance_of?(Array)
            params[k] << v
          else
            params[k] = [cur, v]
          end
        else
          params[k] = v
        end
      end
      params
    end
  end
end
