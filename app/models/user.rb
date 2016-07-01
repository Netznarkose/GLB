class User < ActiveRecord::Base
  has_many :entries
  has_many :comments
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # divise-validatable validates presence of email and password
  validates :name, :role, presence: true
  after_destroy :check_for_remaining_entries
  scope :allowed_for_entries, -> { where(role: %w(admin editor author commentator)) }

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

  Super_Admin_Email = 'ulrich.apel@uni-tuebingen.de'.freeze

  def assign_remaining_entries_to_super_admin # ? split into two mehtods
    super_admin = User.find_by_email(Super_Admin_Email)
    super_admin_entries_count_before = super_admin.entries.count
    super_admin.entries << entries
    if super_admin.entries.size == (super_admin_entries_count_before + entries.size)
      entries.delete_all
    end
  end

  def check_for_remaining_entries
    raise 'User still holds entries' if entries.any?
  end
end
