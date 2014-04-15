require 'spec_helper'

describe Category do
  describe 'validations' do
    it 'should have a valid factory' do
      build(:category).should be_valid
    end

    it 'should fail without required fields' do
      build(:category, name: '').should_not be_valid
      build(:category, display_order: nil).should_not be_valid
    end

    it 'should fail without unique fields' do
      c = create :category
      build(:category, name: c.name).should_not be_valid
      build(:category, name: c.name.upcase).should_not be_valid
      build(:category, display_order: c.display_order).should_not be_valid
    end

    it 'should fail if display_order is non-numeric' do
      build(:category, display_order: 'a').should_not be_valid
    end
  end

  describe 'associations' do
    it { should have_many :tickets }
  end
end
