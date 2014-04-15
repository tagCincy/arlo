class Ticket < ActiveRecord::Base

  belongs_to :category
  belongs_to :priority
  belongs_to :status

  belongs_to :account
  belongs_to :assignee, class_name: 'Account', foreign_key: :assignee_id

  validates_presence_of :subject, :content, :category, :priority, :status
end
