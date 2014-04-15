class QuestionPolicy < ApplicationPolicy
  attr_reader :account, :record

  def initialize(account, record)
    @account = account
    @question = record
  end

  def show?
    @account.super? || group?
  end

  def update?
    @account.super? ||  owner? || (group? && @account.admin?)
  end

  def destroy?
    @account.super? ||  owner?
  end

  private

  def owner?
    @question.account == @account
  end

  def group?
    @question.group.in? @account.groups
  end

end