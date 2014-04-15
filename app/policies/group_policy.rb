class GroupPolicy < ApplicationPolicy

  attr_reader :account, :record

  def initialize(account, record)
    @account = account
    @group = record
  end

  def show?
    @account.super? || member?
  end

  def create?
    elevated?
  end

  def update?
    @account.super? ||  group_admin?
  end

  def destroy?
    @account.super? ||  group_admin?
  end

  private

  def member?
    @group.accounts.include? @account
  end

  def elevated?
    !@account.user?
  end

  def group_admin?
    member? && @account.admin?
  end
end