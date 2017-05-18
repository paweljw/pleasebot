# frozen_string_literal: true
require 'spec_helper'

describe Repository do
  let(:data) do
    {
      'owner' => { 'login' => 'paweljw' },
      'name' => 'pleasebot'
    }
  end

  subject { described_class.new(data) }

  describe '#owner' do
    it { expect(subject.owner).to eq 'paweljw' }
  end

  describe '#name' do
    it { expect(subject.name).to eq 'pleasebot' }
  end  

  describe '#full_name' do
    it { expect(subject.full_name).to eq 'paweljw/pleasebot' }
  end
end
