require "treasure_hunter"
require "thor"
require "treasure_hunter/config"
require "treasure_hunter/repository"
require "treasure_hunter/query"

module TreasureHunter
  class Runner < Thor

    # init
    desc "init", "clone query repository or reinitialize an existing one."
    def init
      Repository.init rescue print_error
    end

    # update
    desc "update", "pull from query repository."
    def update
      Repository.update rescue print_error
    end

    # list
    desc "list", "list query"
    def list
      Query.list rescue print_error
    end

    # show
    desc "show [query]", "show query"
    def show(query_path)
      Query.show query_path rescue print_error
    end

    # query
    desc "query [query] [arg...]", "execute query"
    def query(query_path, *args)
      Query.query(query_path, *args) rescue print_error
    end

    # show_job
    desc "job:show [job_id]", "show query status"
    def show_job(job_id = :last_time)
      Query.show_job(job_id) rescue print_error
    end

    private
    def print_error
      $stderr.puts "ERROR: #{$!.class} - #{$!}"
      # $stderr.puts $!.backtrace
    end

  end
end
