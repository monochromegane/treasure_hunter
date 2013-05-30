require "yaml"
require "find"
require "td/client"
require "td/command/runner"
require "treasure_hunter/config"

module TreasureHunter

  class QueryError < StandardError;  end
  class QueryNotFoundError < QueryError; end
  class QueryParseError < QueryError; end
  class QueryJobError < QueryError; end

  class Query

    def self.attribute(*attributes)
      attributes.each do |attr|
        define_method(attr) do
          @query[attr.to_s]
        end
      end 
    end

    attr_reader :raw
    attribute   :name, :description, :database, :query

    def initialize(query_path, *args)
      load(query_path, *args)
    end

    def self.list
      Find.find self.working_dir do |f|
        Find.prune if f == "#{Config.working_dir}/.git"
        next if File.directory?(f)
        query = new(f)
        file_name = f.gsub(/#{Config.working_dir}\//, "")
        puts "#{file_name} # #{query.name}"
      end
    end

    def self.show(query_path)
      puts new("#{Config.working_dir}/#{query_path}").raw
    end

    def self.query(query_path, *args)
      query = new("#{Config.working_dir}/#{query_path}", *args)
      tee {TreasureData::Command::Runner.new.run ["query", "-d", query.database, query.query]}
    end

    def self.show_job(job_id)
      job_id = last_job_id if job_id == :last_time
      TreasureData::Command::Runner.new.run ["job:show", job_id]
    end

    private
    def load(query_path, *args)
      @path = query_path
      @raw = read(query_path)
      args.each {|arg| @raw.sub!("?", arg)} unless args.empty?
      @query = load_yaml(@raw)
    end

    def self.working_dir
      unless FileTest.exist?(Config.working_dir)
        e = QueryNotFoundError.new("No such query directory [#{Config.working_dir}]. Run 'th init' first.")
        raise e
      end
      Config.working_dir
    end

    def read(path)
      begin
        raw = File.read(path)
      rescue
        e = QueryNotFoundError.new("No such query file [#{path}].")
        # e.set_backtrace($!.backtrace)
        raise e
      end
      raw
    end

    def load_yaml(yaml)
      begin
        query = YAML.load(yaml)
      rescue
        e = QueryParseError.new("Invalid query format [#{@path}].")
        e.set_backtrace($!.backtrace)
        raise e
      end
      valid_query(query)
    end

    def valid_query(query)
      [:name, :database, :query].each do |required|
        unless query.is_a?(Hash) and query.has_key? required.to_s
          e = QueryParseError.new("Invalid query format [#{@path}]. [name, database, query] is required item.")
          raise e
        end
      end
      query
    end

    def self.last_time_path
      File.join(ENV["HOME"], ".th", "last_time")
    end

    def self.tee
      $stderr = File.open(last_time_path, "w")
      yield
      $stderr.close
      $stderr = STDERR
      STDERR.puts(File.read(last_time_path))
    end

    def self.last_job_id
      last_time = File.read(last_time_path)
      unless last_time.include?("is queued")
        e = QueryJobError.new("Failed last time job, or Job is yet queued.")
        raise e
      end
      last_time.split(" ")[1]
    end

  end
end
