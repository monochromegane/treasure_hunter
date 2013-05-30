require "yaml"

module TreasureHunter
  class ConfigError < StandardError; end
  class ConfigNotFoundError < ConfigError; end
  class ConfigParseError < ConfigError; end

  class Config
    @@path = File.join(ENV["HOME"], ".th", "th.conf")

    def initialize(path)
      @path = path
    end

    def self.path=(path)
      @@path = path
    end

    def self.repository
      Config.read["repository"]
    end

    def self.working_dir
      File.join(ENV["HOME"], ".th", "query")
    end

    def self.read
      new(@@path).read
    end

    def read
      begin
        config = YAML.load_file(@path)
      rescue Errno::ENOENT
        e = ConfigNotFoundError.new("No such config file [#{@path}].")
        e.set_backtrace($!.backtrace)
        raise e
      rescue
        e = ConfigParseError.new("Invalid config file format [#{@path}].")
        e.set_backtrace($!.backtrace)
        raise e
      end
      validate_config(config)
    end

    private
    def validate_config(config)
      unless config.is_a?(Hash) && config.has_key?("repository")
        e = ConfigParseError.new("Invalid config file format [#{@path}]. [repository] is required item.")
        raise e
      end
      config
    end
  end
end
