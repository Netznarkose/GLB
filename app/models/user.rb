class User < ActiveRecord::Base
  has_many :entries
  has_many :comments
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # divise-validatable validates presence of email and password
  validates :name, :role, presence: true
  scope :allowed_for_entries, -> { where(role: %w(admin editor author commentator)) }
  before_destroy :check_for_remaining_entries


  def assignments
    Assignment.where(recipient_id: self.id)
  end

  def admin?
    role == 'admin'
  end

  def editor?
    role == 'editor'
  end

  def author?
    role == 'author'
  end

  def commentator?
    role == 'commentator'
  end

  def guest?
    role == 'guest'
  end

  def self.default_admin
    find_by_email('ulrich.apel@uni-tuebingen.de')
  end

  def check_for_remaining_entries
    raise 'User still holds entries' if entries.any?
  end
end
