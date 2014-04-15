require 'spec_helper'

describe Question do
  describe 'validations' do

    it 'should have a valid factory' do
      build(:question).should be_valid
    end

    it 'should be invalid without required fields' do
      build(:question, title: '').should_not be_valid
      build(:question, content: '').should_not be_valid
      build(:question, tags: []).should_not be_valid
    end

  end

  describe 'associations' do
    it { should belong_to :account }
    it { should belong_to :group }
    it { should have_many :answers }
    it { should have_many :question_tags }
    it { should have_many(:tags).through(:question_tags) }
    it { should have_many(:comments) }
    it { should belong_to :accepted_answer }
  end
end
