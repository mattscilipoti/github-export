require 'spec_helper'
require File.expand_path('../lib/github-export', File.dirname(__FILE__))

def test_fixture_repo_uri(suffix = '')
  URI.join('https://api.github.com/repos/mattscilipoti/github-export-fixture/', suffix)
end

describe "GET list of issues" do
  use_vcr_cassette

  subject { GHE::Issues.new(test_fixture_repo_uri) }

  it 'should return 1 issue' do
    subject.should have(1).keys
  end

  it "should have the issue #1's title" do
    subject.first['title'].should eql("TEST ISSUE #1"), subject.first
  end

  it "should have the issue #1's closed_by" do
    subject.first['closed_by'].should eql("")
  end

  it "should provide some attributes of each issue" do
    subject.first.should have(16).keys
  end
end
