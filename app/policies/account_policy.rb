class AccountPolicy < ApplicationPolicy
  attr_reader :account, :record

  def initialize(account, record)
    @account = account
    @record = record
  end

  def update?
    Rails.logger.debug @record.inspect
    Rails.logger.debug @account.inspect
    @account.super? ||  account?
  end

  def destroy?
    @account.super?
  end

  private

  def account?
    @record == @account
  end

end
