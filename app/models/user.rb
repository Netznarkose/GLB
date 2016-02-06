class User < ActiveRecord::Base
  has_many :entries
  has_many :comments
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true
  validates :email, presence: true

  after_destroy :assign_remaining_entries_to_superadmin

  scope :allowed_for_entries, ->{ where( role: ['superadmin', 'admin', 'editor']) }




  def admin?
    role == "admin" || role == 'superadmin'
  end

  def editor?
    role == "editor"
  end

  def search_entries(query)
    self.entries.where("japanische_umschrift LIKE ? OR kanji LIKE ? OR namenskuerzel = ? OR kennzahl = ? OR romaji_order LIKE ?", "%#{query}%", "%#{query}%", "#{query}", "#{query}", "%#{query}%")
  end

  def assign_remaining_entries_to_superadmin 
    super_admin = User.find_by_role('superadmin')
    super_admin.entries << self.entries
  end
end
