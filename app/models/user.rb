class User < ActiveRecord::Base
  has_many :entries
  has_many :comments
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # divise-validatable validates presence of email and password
  validates :name, :role, presence: true

  after_destroy :check_for_remaining_entries

  scope :allowed_for_entries, -> { where(role: ['admin', 'editor', 'author', 'commentator']) }

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

  SuperAdminEmail = 'ulrich.apel@uni-tuebingen.de'
  def assign_remaining_entries_to_super_admin
    binding.pry
    super_admin = User.find_by_email(SuperAdminEmail)
    super_admin_entries_total = super_admin.entries.count
    super_admin.entries << entries
    if super_admin.entries.size == (super_admin_entries_total + self.entries.size)
      self.entries.delete_all
    end
  end
  def check_for_remaining_entries
    if self.entries.any?
      raise 'User still holds entries'
    end
  end
end
