require 'spec_helper'

describe Tag do

  describe 'validations' do
    it 'should have a valid factory' do
      build(:tag).should be_valid
    end

    it 'should fail without required fields' do
      build(:tag, name: '').should_not be_valid
      build(:tag, description: '').should_not be_valid
    end

    it 'should fail without unique name' do
      t = create :tag
      build(:tag, name: t.name).should_not be_valid
      build(:tag, name: t.name.upcase).should_not be_valid
    end
  end

  describe 'associations' do
    it { should have_many(:question_tags) }
    it { should have_many(:questions).through(:question_tags) }
  end
end
