# frozen_string_literal: true

require 'spec_helper'

describe RedisService do
  subject { described_class.instance }

  let(:redis) { Redis.new(url: Pleasebot.redis_url) }
  let(:pull_request) { double('pull_request', id: 666) }

  before { redis.flushall }

  describe '#exist?' do
    context 'when pull request does not exist' do
      it { expect(subject.exist?(pull_request)).to be_falsey }
    end

    context 'when pull request exists' do
      before { redis.set(pull_request.id, true) }

      it { expect(subject.exist?(pull_request)).to be_truthy }
    end
  end

  describe '#mark_done' do
    it 'marks pull request in redis' do
      subject.mark_done(pull_request)
      expect(redis.get('666')).to be
    end
  end
end
