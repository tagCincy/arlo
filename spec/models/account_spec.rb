require 'spec_helper'

describe Account do

  describe 'validations' do

    it 'should have a valid factory' do
      build(:account).should be_valid
    end

    it 'should fail without a username' do
      build(:account, username: '').should_not be_valid
    end

    it 'should fail without a unique username' do
      a = create(:account)
      build(:account, username: a.username).should_not be_valid
      build(:account, username: a.username.upcase).should_not be_valid
    end

    it 'should fail with an invalid username format' do
      build(:account, username: 'foo bar').should_not be_valid
      build(:account, username: 'f*0bar').should_not be_valid
    end

    it 'should pass with valid username format' do
      build(:account, username: 'foo.bar').should be_valid
      build(:account, username: 'foo-bar').should be_valid
      build(:account, username: 'foo_bar').should be_valid
      build(:account, username: 'foobar1').should be_valid
      build(:account, username: 'FooBar').should be_valid
    end
  end

  describe 'assocations' do
    it { should belong_to :user }
    it { should accept_nested_attributes_for :user }
    it { should have_many(:groups).through(:memberships) }
    it { should have_many :questions }
    it { should have_many :answers }
    it { should have_many :comments }
  end
end