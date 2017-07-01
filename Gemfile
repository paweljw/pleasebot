# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.4.1'

gem 'octokit'
gem 'rack-app'
gem 'redis'
gem 'redlock'

group :development, :test do
  gem 'pry'
  gem 'rspec'
end

group :test do
  gem 'fakeredis', require: 'fakeredis/rspec'
end
