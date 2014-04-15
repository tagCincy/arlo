class Tag < ActiveRecord::Base

  has_many :question_tags
  has_many :questions, through: :question_tags, source: :question

  validates :name,
            presence: true,
            uniqueness: {case_sensitive: false}

  validates_presence_of :description
end
