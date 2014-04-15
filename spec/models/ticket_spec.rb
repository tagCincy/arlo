require 'spec_helper'

describe Ticket do

  describe 'validations' do

    it 'should have a valid association' do
      build(:ticket).should be_valid
    end

    it 'should fail without required fields' do
      build(:ticket, subject: '').should_not be_valid
      build(:ticket, content: '').should_not be_valid
      build(:ticket, category: nil).should_not be_valid
      build(:ticket, status: nil).should_not be_valid
      build(:ticket, priority: nil).should_not be_valid
    end
  end

  describe 'associations' do
    it { should belong_to :account }
    it { should belong_to :assignee }
    it { should belong_to :category }
    it { should belong_to :status }
    it { should belong_to :priority }
  end
end
