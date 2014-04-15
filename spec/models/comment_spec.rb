require 'spec_helper'

describe Comment do
  describe 'validations' do
    it 'should have a valid factory' do
      build(:comment).should be_valid
    end

    it 'should fail without required fields' do
      build(:comment, content: '').should_not be_valid
      build(:comment, commentable_id: nil).should_not be_valid
      build(:comment, commentable_type: '').should_not be_valid
    end

    it 'should fail without acceptable commentable type' do
      build(:comment, commentable_type: 'Foo').should_not be_valid
    end

    it 'should pass with any of the acceptable commentable types' do
      q = create :question
      a = create :answer
      t = create :ticket

      build(:comment, commentable: q).should be_valid
      build(:comment, commentable: a).should be_valid
      build(:comment, commentable: t).should be_valid
    end
  end

  describe 'associations' do
    it { should belong_to :account }
    # it { should belong_to :commentable }
  end
end
