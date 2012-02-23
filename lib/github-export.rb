require "github-export/version"
require 'nestful'

module GHE
  class Issues
    include Enumerable

    def initialize(repo_uri)
      @repo_uri = repo_uri
    end

    end

    def each &block
      issues.each{|member| block.call(member)}
    end

    def find(number)
      get_json repo_uri.join(suffix, number.delete('#'))
    end

    def get_json(url, options = {})
      Nestful.json_get url
      #issues = RestClient.get(url, {:accept => :json}.merge(options))
      #JSON.parse(issues)
    end

    def repo_uri(suffix = '')
      URI.join(@repo_uri, suffix)
    end

    def suffix
      'issues'
    end

private

    def issues(options = {})
      @issues ||= get_json(repo_uri(suffix), options)
    end
  end
end
