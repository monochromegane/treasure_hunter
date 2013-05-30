require "spec_helper"
require "treasure_hunter/config"

describe TreasureHunter::Config do

  let(:config){TreasureHunter::Config}

  describe "#working_dir" do
    it "should be return 'query'" do
      config.working_dir.should eq(File.join(ENV["HOME"], ".th", "query"))
    end
  end

  describe "#repository" do
    it "should be return repository value in config file" do
      config.path = "spec/conf/valid.conf"
      config.repository
    end
  end

  describe "#read" do

    context "when config file dose not found" do
      it "should raise error" do
        config.path = "spec/conf/not_exist.conf"
        expect {config.repository}.to raise_error(TreasureHunter::ConfigNotFoundError)
      end
    end

    context "when 'repository' item dose not exist." do
      it "should raise error" do
        config.path = "spec/conf/invalid.conf"
        expect {config.repository}.to raise_error(TreasureHunter::ConfigParseError)
      end
    end

    context "when successful" do
      it "should be return repository value in config file" do
        config.path = "spec/conf/valid.conf"
        config.repository.should eq("spec/query_src") 
      end
    end
  end
end

