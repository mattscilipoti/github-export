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

  it "should have the first issue's title" do
    subject.first['title'].should eql("TEST ISSUE #1"), subject.first
  end
end
