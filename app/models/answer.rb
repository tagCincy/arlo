class Answer < ActiveRecord::Base
  belongs_to :account
  belongs_to :question

  has_many :comments, as: :commentable

  validates_presence_of :content
end
