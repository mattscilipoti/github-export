require "github-export/version"
require "github-export/logging"
require 'nestful'

log_file = File.expand_path('../log/github-export.log', File.dirname(__FILE__))
Logging.logger = Logger.new(log_file, 'daily' )

module GHE
  # Acts as an array of hashes.  It is enumerable.
  class Issues
    include Enumerable
    include Logging

    def initialize(repo_uri)
      @issues = {}
      @repo_uri = repo_uri
    end

    def closed
      issues('state' => 'closed')
    end

    def each &block
      issues.each{|member| block.call(member)}
    end

    # Finds a single issue by number (same id as in url)
    def find(number)
      # Ensure the middle string is not an "endpoint"
      # see: http://apidock.com/ruby/v1_9_2_180/URI/join/class
      issue_uri = URI.join(repo_uri, "#{suffix}/", number.delete('#'))
      logger.debug "Finding Issue: #{issue_uri}"
      get_json issue_uri
    end

    def get_json(url, options = {})
      Nestful.json_get url, options
      #issues = RestClient.get(url, {:accept => :json}.merge(options))
      #JSON.parse(issues)
    end

    def repo_uri(suffix = '')
      URI.join(@repo_uri, suffix)
    end

    def suffix
      'issues'
    end

    # Exports the list of issues to the specified dir.
    # Since the returned list does not contain all the attributes for each issue
    #   Each issue is gathered individually and saved ot its own file.
    def to_dir(base_dir = '.')
      path = File.join(base_dir, suffix)
      FileUtils.mkdir_p(path)
      self.each do |issue|
        # list contains partial info for each issue, retrieving individual
        # being truly restful, the list provides the url.  sweet.
        issue_url = issue.fetch('url')
        logger.info "Retrieving issue: #{issue_url}"
        issue_json = get_json(issue_url)
        file = File.join(path, "#{issue['id']}.json")
        logger.info "Writing issue ##{issue['number']} to #{file}"
        File.open(file, "w"){|f| f.write(issue_json)}
      end
    end

private

    def issues(options = {})
      # need to cache each collection of issues
      @issues[options.hash] ||= get_json(repo_uri(suffix), options).tap do
        logger.debug "Retrieving Issue List: #{repo_uri(suffix)}, #{options}"
      end
    end
  end
end
