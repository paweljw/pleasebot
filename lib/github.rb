# frozen_string_literal: true

require 'octokit'
require 'forwardable'

class Github
  include Singleton
  extend Forwardable

  delegate [:request_pull_request_review, :add_comment] => :@octokit

  def initialize
    @octokit = Octokit::Client.new(access_token: Pleasebot.access_token)
  end
end
