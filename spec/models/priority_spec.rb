require 'spec_helper'

describe Priority do
  describe 'validations' do
    it 'should have a valid factory' do
      build(:priority).should be_valid
    end

    it 'should fail without required fields' do
      build(:priority, name: '').should_not be_valid
      build(:priority, display_order: nil).should_not be_valid
    end

    it 'should fail without unique fields' do
      c = create :priority
      build(:priority, name: c.name).should_not be_valid
      build(:priority, name: c.name.upcase).should_not be_valid
      build(:priority, display_order: c.display_order).should_not be_valid
    end

    it 'should fail if display_order is non-numeric' do
      build(:priority, display_order: 'a').should_not be_valid
    end
  end

  describe 'associations' do
    it { should have_many :tickets }
  end
end
