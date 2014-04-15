require 'spec_helper'

describe Answer do

  describe 'validations' do
    it 'should have a valid factory' do
      build(:answer).should be_valid
    end

    it 'should be invalid without require fields' do
      build(:answer, content: '').should_not be_valid
    end
  end

  describe 'associations' do
    it { should belong_to :account }
    it { should belong_to :question }
    it { should have_many :comments }
  end
end
