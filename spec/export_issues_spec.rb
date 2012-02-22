require 'spec_helper'
require 'nestful'

def test_fixture_repo_uri(suffix = '')
  URI.join('https://api.github.com/repos/mattscilipoti/github-export-fixture/', suffix)
end

module GHE
  class Issues
    include Enumerable

    def initialize(repo_uri)
      @repo_uri = repo_uri
    end

    def repo_uri(suffix = '')
      URI.join(@repo_uri, suffix)
    end

    def each &block
      issues.each{|member| block.call(member)}
    end

private

    def issues
      @issues ||= Nestful.json_get repo_uri('issues')
      #issues = RestClient.get(url, {:accept => :json})
      #JSON.parse(issues)
    end
  end
end

describe "GET list of issues" do
  use_vcr_cassette

  subject { GHE::Issues.new(test_fixture_repo_uri) }

  it 'should return 1 issue' do
    subject.should have(1).keys
  end

  it "should have the first issue's title" do
    subject.first['title'].should eql("TEST ISSUE #1"), subject.first
  end
end
