class Account < ActiveRecord::Base

  belongs_to :user, dependent: :destroy

  has_many :questions
  has_many :tickets
  has_many :comments
  has_many :answers

  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships

  validates :username,
            presence: true,
            uniqueness: {case_sensitive: false},
            format: /\A([A-Za-z0-9._-]+)\Z/i

  accepts_nested_attributes_for :user

  enum role: [:user, :tech, :admin, :super]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end
end
