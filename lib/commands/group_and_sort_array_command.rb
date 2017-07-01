# frozen_string_literal: true

require_relative './base_command'

class GroupAndSortArrayCommand < BaseCommand
  def initialize(array, required_keys)
    @array = array
    @required_keys = required_keys
  end

  def call
    drop_non_required_keys
    group_array
    ensure_required_keys
    sort_array
    array
  end

  private

  attr_reader :array, :required_keys

  def drop_non_required_keys
    @array = array.select { |key| required_keys.include?(key) }
  end

  def group_array
    @array = array.group_by { |entry| entry }.map { |item, entries| [item, entries.count] }
  end

  def sort_array
    @array = array.sort_by { |_, entries| entries }
  end

  def ensure_required_keys
    firsts = array.map(&:first)
    required_keys.shuffle.each { |required_person| @array << [required_person, 0] unless firsts.include?(required_person) }
  end
end
