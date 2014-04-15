class Group < ActiveRecord::Base

  after_validation { |g| g.code = g.code.downcase }
  after_create :initialize_tenant

  cattr_accessor :current_id

  has_many :memberships, dependent: :destroy
  has_many :accounts, through: :memberships

  has_many :questions

  validates :name,
            uniqueness: {case_sensitive: false},
            presence: true

  validates :code,
            uniqueness: {case_sensitive: false},
            presence: true,
            format: /\A([A-Za-z]{2,20})\Z/i

  validate :prevent_code_update, on: :update

  private

  def initialize_tenant
    Apartment::Database.create(self.code)
  end

  def prevent_code_update
    if code != code_was
      self.errors.add(:code, "Group code cannot be updated.")
    end
  end

end
