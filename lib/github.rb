# frozen_string_literal: true

require 'octokit'
require 'forwardable'
require 'singleton'

require_relative 'commands/group_and_sort_array_command'

class Github
  include Singleton
  extend Forwardable

  delegate %i(request_pull_request_review add_comment) => :@octokit

  def initialize
    @octokit = Octokit::Client.new(access_token: Pleasebot.access_token)
  end

  def open_pull_requests
    Pleasebot.managed_repositories.flat_map do |repository|
      @octokit.pull_requests(repository, state: 'open')
    end
  end

  def least_requested_reviewers(only, count)
    GroupAndSortArrayCommand.call(requested_reviewers_logins, only).take(count)
  end

  private

  def requested_reviewers
    open_pull_requests.flat_map { |pull_request| pull_request[:requested_reviewers] }
  end

  def requested_reviewers_logins
    requested_reviewers.flat_map { |reviewer| reviewer[:login] }
  end
end
