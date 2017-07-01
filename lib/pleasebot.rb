# frozen_string_literal: true

class Pleasebot
  class << self
    def redis_url
      @redis_url ||= ENV.fetch('REDIS_URL', 'redis://127.0.0.1:6379/1')
    end

    def people_in_team
      @people_in_team ||= ENV.fetch('PEOPLE_IN_TEAM', 4).to_i
    end

    def managed_repositories
      @managed_repositories ||= ENV.fetch('MANAGED_REPOSITORIES', '').split(',')
    end

    def min_assignees
      @min_assignees ||= people_in_team - 1
    end

    def reviewers
      @reviewers ||= ENV.fetch('MIN_REVIEWERS', 2).to_i
    end

    def access_token
      @access_token ||= ENV['ACCESS_TOKEN']
    end
  end
end
