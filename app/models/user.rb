class User < ActiveRecord::Base
  has_many :entries
  has_many :comments
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # divise-validatable validates presence of email and password
  validates :name, :role, presence: true

  after_destroy :assign_remaining_entries_to_ulrich_appel

  scope :allowed_for_entries, -> { where(role: ['admin', 'editor', 'chiefeditor', 'commentator']) }

  def admin?
    role == 'admin'
  end

  def chief_editor?
    role == 'chiefeditor'
  end

  def editor?
    role == 'editor'
  end

  def commentator?
    role == 'commentator'
  end

  def guest?
    role == 'guest'
  end

  def assign_remaining_entries_to_ulrich_appel
    super_admin = User.find_by_email('ulrich.apel@uni-tuebingen.de')
    super_admin.entries << entries
  end
end
