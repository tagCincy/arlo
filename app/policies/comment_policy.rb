class CommentPolicy < ApplicationPolicy

  attr_reader :account, :record

  def initialize(account, record)
    @account = account
    @comment = record
  end

  def update?
    @account.super? ||  owner?
  end

  def destroy?
    @account.super? ||  owner?
  end

  private

  def owner?
    @comment.account == @account
  end

end