# see http://stackoverflow.com/questions/917566/ruby-share-logger-instance-among-module-classes
#require 'logging'
require 'forwardable'

module Logging
  extend Forwardable
  def_delegators :logger, :level
#  delegate :level, :to => :logger

  # This is the magical bit that gets mixed into your classes
  def logger
    Logging.logger
  end

  # Global, memoized, lazy initialized instance of a logger
  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def self.logger=(logger)
    @logger = logger
  end
end
