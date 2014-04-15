class Priority < ActiveRecord::Base
  has_many :tickets

  validates :name,
            presence: true,
            uniqueness: {case_sensitive: false}

  validates :display_order,
            presence: true,
            uniqueness: true,
            numericality: true
end
