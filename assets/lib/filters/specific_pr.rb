# frozen_string_literal: true

module Filters
  class SpecificPr
    def initialize(pull_requests:, input: Input.instance)
      @pull_requests = pull_requests
      @input = input
    end

    def pull_requests
      if @input.source.pr
        @pull_requests.delete_if { |pr| pr.id.to_s != @input.source.pr.to_s }
      else
        @pull_requests
      end
    end
  end
end
