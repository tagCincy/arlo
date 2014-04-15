require 'spec_helper'

describe User do

  describe 'validations' do
    it 'should have a valid factory' do
      build(:user).should be_valid
    end

    it 'should fail without required fields' do
      build(:user, first_name: '').should_not be_valid
      build(:user, last_name: '').should_not be_valid
      build(:user, email: '').should_not be_valid
      build(:user, password: '').should_not be_valid
    end

    it 'should fail without unique fields' do
      u = create(:user)
      build(:user, email: u.email).should_not be_valid
      build(:user, email: u.email.upcase).should_not be_valid
    end

    it 'should fail with an invalid email format' do
      build(:user, email: 'test').should_not be_valid
      build(:user, email: 'test@email').should_not be_valid
      build(:user, email: 'test@email..com').should_not be_valid
      build(:user, email: 'test@email.').should_not be_valid
      build(:user, email: 'test@ema_il.com').should_not be_valid
    end

    it 'should pass with valid email format' do
      build(:user, email: 'test@email.com').should be_valid
      build(:user, email: 'test1@email.com').should be_valid
      build(:user, email: 'te.st@email.com').should be_valid
      build(:user, email: 'te-st@email.com').should be_valid
      build(:user, email: 'te_st@email.com').should be_valid
      build(:user, email: 'test@ema.il.com').should be_valid
      build(:user, email: 'test@ema-il.com').should be_valid
      build(:user, email: 'test@email1.com').should be_valid
    end

    it 'should fail without a password confirmation' do
      build(:user, password_confirmation: '').should_not be_valid
      build(:user, password_confirmation: 'password123').should_not be_valid
    end
  end

  describe 'associations' do
    it { should have_one :account }
  end

end