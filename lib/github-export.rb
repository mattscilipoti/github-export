require "github-export/version"
require 'nestful'

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
