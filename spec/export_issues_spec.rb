require 'spec_helper'
require 'nestful'

def test_fixture_repo_uri(suffix = '')
  URI.join('https://api.github.com/repos/mattscilipoti/github-export-fixture/', suffix)
end

def issues
  url = test_fixture_repo_uri('issues')
  return Nestful.json_get url
  #issues = RestClient.get(url, {:accept => :json})
  #JSON.parse(issues)
end

describe "GET list of issues" do
  use_vcr_cassette

  subject { issues }

  it 'should return 1 issue' do
    subject.should have(1).keys
  end

  it "should have the first issue's title" do
    subject.first['title'].should eql("TEST ISSUE #1"), subject.first
  end
end
