require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

PEOPLE_IN_TEAM = ENV.fetch('PEOPLE_IN_TEAM', 4).to_i
ASSIGNEES_ENOUGH = PEOPLE_IN_TEAM / 2
REDIS_URL = ENV.fetch('REDIS_URL', 'redis://127.0.0.1:6379/1')
ACCESS_TOKEN = ENV.fetch('ACCESS_TOKEN', '')
REDIS = Redis.new(url: REDIS_URL)
REDLOCK = Redlock::Client.new([REDIS])
OCTOKIT = Octokit::Client.new(:access_token => ACCESS_TOKEN)

require_relative './lib/pull_request'
require_relative './lib/repository'

class App < Rack::App
  payload do
    parser do
      accept :json
    end
  end

  post '/' do
    if payload['action'] == 'assigned'
      repo = Repository.new(payload['repository'])
      pull_request = PullRequest.new(repo, payload['pull_request'], REDIS, OCTOKIT)
      REDLOCK.lock("#{pull_request.id}-locksies", 2000) do |locked|
        if locked
          if pull_request.assignable?
            pull_request.assign!
          else
            puts 'Not enough assignees or pull request known as assigned'
          end        
        end
      end
    end
  end
end

run App
