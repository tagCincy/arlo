class Question < ActiveRecord::Base

  belongs_to :account
  belongs_to :group

  has_many :answers
  belongs_to :accepted_answer, class_name: 'Answer', foreign_key: :accepted_answer_id

  has_many :question_tags
  has_many :tags, through: :question_tags, source: :tag

  has_many :comments, as: :commentable

  default_scope { where(group_id: Group.current_id) unless Group.current_id.nil?}

  validates_presence_of :title, :content, :tags
end
