# frozen_string_literal: true

require_relative 'lib/bootstrap'

class PleasebotApp < Rack::App
  payload do
    parser do
      accept :json
    end
  end

  post '/' do
    PleaseCommand.call(payload)
  end
end

run PleasebotApp
