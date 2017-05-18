# frozen_string_literal: true
require 'spec_helper'

describe PullRequestValidator do
  subject { described_class.new(pull_request) }
  let(:redis) { Redis.new(url: Pleasebot.redis_url) }

  before { redis.flushall }

  describe '#valid?' do
    context 'when pull request is not assigned' do
      let(:pull_request) { instance_double('PullRequest', assigned?: false) }
      it { expect(subject.valid?).to_not be }
    end

    context 'when not enough people to review' do
      let(:pull_request) { instance_double('PullRequest', assigned?: true, assignees_except_author: []) }
      it { expect(subject.valid?).to_not be }
    end

    context 'when pull request already done' do
      let(:pull_request) do
        instance_double('PullRequest', assigned?: true, assignees_except_author: ['one', 'two', 'three'], id: '666')
      end

      before { redis.set('666', true) }

      it { expect(subject.valid?).to_not be }
    end

    context 'when pull request is ready' do
      let(:pull_request) do
        instance_double('PullRequest', assigned?: true, assignees_except_author: ['one', 'two', 'three'], id: '666')
      end

      it { expect(subject.valid?).to be }
    end
  end
end
