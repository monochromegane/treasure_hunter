require "fileutils"
require "git"

module TreasureHunter
  class RepositoryNotFoundError < StandardError; end

  class Repository
    def self.init
      self.delete
      Git.clone(Config.repository, Config.working_dir)
    rescue
      e = RepositoryNotFoundError.new($!.to_s)
      e.set_backtrace($!.backtrace)
      raise e
    end

    def self.update
      g = Git.open(Config.working_dir)
      g.fetch
      g.merge("origin/master")
    rescue
      e = RepositoryNotFoundError.new($!.to_s)
      e.set_backtrace($!.backtrace)
      raise e
    end

    def self.delete
      FileUtils.rm_r(Dir.glob(Config.working_dir), force: true)
    end
  end
end
