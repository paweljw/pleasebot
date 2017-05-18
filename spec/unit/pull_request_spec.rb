# frozen_string_literal: true
require 'spec_helper'

describe PullRequest do
  let(:data) do
    {
      'assignees' => [
        { 'login' => 'paweljw' },
        { 'login' => 'steamshard' }
      ],
      'id' => '666',
      'number' => '3',
      'user' => { 'login' => 'paweljw' }
    }
  end

  subject { described_class.new(data) }

  describe '#assignees' do
    it { expect(subject.assignees).to match_array(%w(paweljw steamshard)) }
  end

  describe '#id' do
    it { expect(subject.id).to eq '666' }
  end

  describe '#number' do
    it { expect(subject.number).to eq 3 }
  end

  describe '#author' do
    it { expect(subject.author).to eq 'paweljw' }
  end

  describe '#assignees_except_author' do
    it { expect(subject.assignees_except_author).to match_array %w(steamshard) }
  end

  describe '#assigned?' do
    context 'with not enough people' do
      it { expect(subject.assigned?).to be_falsey }
    end

    context 'with enough people' do
      let(:data) do
        {
          'assignees' => [
            { 'login' => 'paweljw' },
            { 'login' => 'steamshard' },
            { 'login' => 'this' },
            { 'login' => 'that' }
          ],
          'id' => '666',
          'number' => '3',
          'user' => { 'login' => 'paweljw' }
        }
      end

      it { expect(subject.assigned?).to be_truthy }
    end
  end

end
