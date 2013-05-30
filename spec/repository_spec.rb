require "spec_helper"
require "treasure_hunter/config"
require "treasure_hunter/repository"

describe TreasureHunter::Repository do

  let(:config){TreasureHunter::Config}
  let(:repo){TreasureHunter::Repository}

  describe "#init" do

    context "when repository dose not found" do
      it "should raise error" do
        config.path = "spec/conf/not_exist_repository.conf"
        expect {repo.init}.to raise_error(TreasureHunter::RepositoryNotFoundError)
      end
    end

    context "when successful" do
      it "should clone repository" do
        config.path = "spec/conf/valid.conf"
        repo.init
        FileTest.exist?(config.working_dir).should be_true
      end
    end
  end

  describe "#update" do
    context "when workind directory dose not exist" do
      it "should raise error" do
        config.path = "spec/conf/valid.conf"
        repo.delete
        expect {repo.update}.to raise_error(TreasureHunter::RepositoryNotFoundError)
      end
    end

    context "when successful" do
      it "should update repository" do
        config.path = "spec/conf/valid.conf"
        repo.init
        repo.update
        FileTest.exist?(config.working_dir).should be_true
      end
    end
  end

  describe "#delete" do
    it "should delete working directory" do
      config.path = "spec/conf/valid.conf"
      repo.delete
      FileTest.exist?(config.working_dir).should be_false
    end
  end
end

