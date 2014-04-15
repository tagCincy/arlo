class AnswerPolicy < ApplicationPolicy
  attr_reader :account, :record

  def initialize(account, record)
    @account = account
    @answer = record
  end

  def create?
    tech?
  end

  def update?
    @account.super? ||  owner?
  end

  def destroy?
    @account.super? ||  owner?
  end

  private

  def owner?
    @answer.account == @account
  end

  def tech?
    !@account.user?
  end
end