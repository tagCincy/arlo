require 'spec_helper'

describe Status do
  describe 'validations' do
    it 'should have a valid factory' do
      build(:status).should be_valid
    end

    it 'should fail without required fields' do
      build(:status, name: '').should_not be_valid
      build(:status, display_order: nil).should_not be_valid
    end

    it 'should fail without unique fields' do
      c = create :status
      build(:status, name: c.name).should_not be_valid
      build(:status, name: c.name.upcase).should_not be_valid
      build(:status, display_order: c.display_order).should_not be_valid
    end

    it 'should fail if display_order is non-numeric' do
      build(:status, display_order: 'a').should_not be_valid
    end
  end

  describe 'associations' do
    it { should have_many :tickets }
  end
end
