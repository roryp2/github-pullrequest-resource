# frozen_string_literal: true

require 'octokit'
require 'time'
require_relative '../pull_request'
require_relative '../utils/duration'

module Filters
  class All
    def initialize(pull_requests: [], input: Input.instance)
      @input = input
    end

    def pull_requests
      @pull_requests ||= Octokit.pulls(input.source.repo, pull_options).map do |pr|
        PullRequest.new(pr: pr) # keep this lazy, specific filters should pull data if they need to
      end
    end

    private

    attr_reader :input

    def pull_options
      t = Time.now - Duration.parse(input.source.check_every).seconds
      options = { state: 'open', sort: 'updated', direction: 'asc', :headers => { 'If-Modified-Since' => t.httpdate } }
      options[:base] = input.source.base if input.source.base
      options
    end
  end
end
