require 'spec_helper'

describe Group do

  describe 'validations' do

    it 'should have a valid factory' do
      build(:group).should be_valid
    end

    it 'should fail without required fields' do
      build(:group, name: '').should_not be_valid
      build(:group, code: '').should_not be_valid
    end

    it 'should fail without unique fields' do
      g = create :group
      build(:group, name: g.name).should_not be_valid
      build(:group, name: g.name.upcase).should_not be_valid
      build(:group, code: g.code).should_not be_valid
      build(:group, code: g.code.upcase).should_not be_valid
    end

    it 'should fail with an invalid code format' do
      build(:group, code: 'a').should_not be_valid
      build(:group, code: 'ab.c').should_not be_valid
      build(:group, code: 'ab1').should_not be_valid
      build(:group, code: '@bc').should_not be_valid
      build(:group, code: 'ab-cd').should_not be_valid
    end

    it 'should pass with valid code formats' do
      (2..10).each do |n|
        c = ''
        n.times { c << Array('a'..'z').sample }
        build(:group, code: c).should be_valid
      end
    end
  end

  describe 'associations' do
    it { should have_many :questions }
    it { should have_many :memberships }
    it { should have_many(:accounts).through(:memberships) }
  end

end
