require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require_relative './pleasebot'

require_relative './redis_service'
require_relative './github'

require_relative './pull_request'
require_relative './repository'

require_relative './commands/please_command'
