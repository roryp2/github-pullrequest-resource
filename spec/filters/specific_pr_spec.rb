# frozen_string_literal: true

require_relative '../../assets/lib/filters/specific_pr'
require_relative '../../assets/lib/pull_request'
require_relative '../../assets/lib/input'
require 'webmock/rspec'

describe Filters::SpecificPr do
  let(:ignore_pr) do
    PullRequest.new(pr: { 'number' => 1, 'head' => { 'sha' => 'abc' }, 'author_association' => 'NONE',
                          'base' => { 'repo' => { 'full_name' => 'user/repo', 'permissions' => { 'push' => true } } } })
  end

  let(:pr) do
    PullRequest.new(pr: { 'number' => 2, 'head' => { 'sha' => 'def' }, 'author_association' => 'OWNER',
                          'base' => { 'repo' => { 'full_name' => 'user/repo', 'permissions' => { 'push' => true } } } })
  end

  let(:pull_requests) { [ignore_pr, pr] }

  it 'returns all pull requests when no pr is specified' do
    payload = { 'source' => { 'repo' => 'user/repo' } }
    filter = described_class.new(pull_requests: pull_requests, input: Input.instance(payload: payload))

    expect(filter.pull_requests).to eq pull_requests
  end

  it 'returns specified pull request when pr is specified' do
    payload = { 'source' => { 'repo' => 'user/repo', 'pr': '2' } }
    filter = described_class.new(pull_requests: pull_requests, input: Input.instance(payload: payload))

    expect(filter.pull_requests).to eq [pr]
  end
end
