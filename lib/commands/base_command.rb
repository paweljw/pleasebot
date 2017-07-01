# frozen_string_literal: true

class BaseCommand
  def self.call(*args)
    new(*args).call
  end

  def call
    not_implemented
  end
end
