require 'spec_helper'
require File.expand_path('../lib/github-export', File.dirname(__FILE__))

def test_fixture_repo_uri(suffix = '')
  URI.join('https://api.github.com/repos/mattscilipoti/github-export-fixture/', suffix)
end

describe "GET list of issues" do
  use_vcr_cassette

  subject { GHE::Issues.new(test_fixture_repo_uri) }

  it 'should return 2 issue' do
    subject.should have(2).keys
  end

  it "should have the issue #1's title" do
    subject.any? {|issue| issue.fetch('title') == "TEST ISSUE #1"}.should be_true, "Couldn't find issue 'TEST ISSUE #1'"
  end

  it "should provide some attributes of each issue" do
    subject.first.should have(16).keys
  end
end

describe GHE::Issues, '.to_dir' do
  use_vcr_cassette
  it "should generate a file for each issue" do
    test_dir = GHE.test_export_dir.join('issues')
    subject.to_dir(test_dir)
    Pathname.new(File.join(test_dir, '3342511.json')).should be_exist #1
    Pathname.new(File.join(test_dir, '3361839.json')).should be_exist #3
  end
end

describe  GHE::Issues, '.closed' do
  describe 'list' do
    use_vcr_cassette
    subject { GHE::Issues.new(test_fixture_repo_uri).closed }

    it "should limit the list to only closed issues" do
      subject.should have(1).items
    end

    it "should be #2" do
      subject.first.fetch('number').should == 2
    end

    it "should populate :closed_at" do
      subject.first.fetch('closed_at').should == '2012-02-22T22:51:58Z'
    end
  end

  describe 'single(#2)' do
    use_vcr_cassette
    subject { GHE::Issues.new(test_fixture_repo_uri).find('#2') }

    it "should populate :closed_at" do
      subject.fetch('closed_at').should == '2012-02-22T22:51:58Z'
    end

    it "should populate :closed_by" do
      subject['closed_by']['login'].should == 'mattscilipoti'
    end
  end
end

end

describe  GHE::Issues, "GET first issue" do
  use_vcr_cassette

  subject { GHE::Issues.new(test_fixture_repo_uri).find('#1') }

  it "should have the first issue's title" do
    subject['title'].should eql("TEST ISSUE #1"), subject
  end

  it "should have 17 keys" do
    subject.should have(17).keys
  end
end
