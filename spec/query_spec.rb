require "spec_helper"
require "treasure_hunter/config"
require "treasure_hunter/repository"
require "treasure_hunter/query"

describe TreasureHunter::Query do

  let(:config){TreasureHunter::Config}
  let(:repo){TreasureHunter::Repository}
  let(:query){TreasureHunter::Query}

  before(:all) do
    TreasureHunter::Config.path = "spec/conf/valid.conf"
    TreasureHunter::Repository.init
  end

  describe "#list" do
    context "when working directory dose not exist" do
      it "should raise error" do
        repo.delete
        expect {query.list}.to raise_error(TreasureHunter::QueryNotFoundError)
        repo.init
      end
    end

    context "when successful" do
      it "should print query list" do
        capture(:stdout){
          query.list
        }.should == <<-EOH
a/b # query_name_a_b
has_replace_field # query_name
        EOH
      end
    end
  end

  describe "#show" do
    context "when query file dose not found" do
      it "should raise error" do
        expect {query.show("not_exist")}.to raise_error(TreasureHunter::QueryNotFoundError)
      end
    end

    context "when successful" do
      it "should print query content" do
        capture(:stdout){
          query.show("has_replace_field")
        }.should == <<-EOH
name: query_name
database: database
query: query ? ?
        EOH
      end
    end
  end

  describe "#query" do
    context "when query file dose not found" do
      it "should raise error" do
        expect {query.query("not_exist")}.to raise_error(TreasureHunter::QueryNotFoundError)
      end
    end

    context "when successful" do
      it "should execute query" do
      end
    end
  end

  describe "#new" do
    context "when has args" do
      it "should replace '?' to 'args'" do
        query.new("spec/query_src/has_replace_field", "a", "b").raw.should == <<-EOH
name: query_name
database: database
query: query a b
        EOH
      end
    end
  end
end
