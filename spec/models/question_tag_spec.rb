require 'spec_helper'

describe QuestionTag do
  describe 'validations' do
    it 'should have a valid factory' do
      build(:question_tag).should be_valid
    end
  end

  describe 'associations' do
    it { should belong_to :question }
    it { should belong_to :tag }
  end
end
