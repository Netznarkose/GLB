class User < ActiveRecord::Base
  has_many :entries
  has_many :comments
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable

  validates :name, :email, :password, :role, presence: true

  after_destroy :assign_remaining_entries_to_ulrich_appel

  scope :allowed_for_entries, ->{ where( role: ['admin', 'editor', 'chiefeditor', 'commentator']) }




  def admin?
    role == "admin" 
  end 
  def chief_editor?
    role == "chiefeditor"
  end

  def editor?
    role == "editor"
  end

  def commentator?
    role == "commentator"
  end

  def guest?
    role == "guest"
  end


  def search_entries(query)
    self.entries.where("japanische_umschrift LIKE ? OR kanji LIKE ? OR namenskuerzel = ? OR kennzahl = ? OR romaji_order LIKE ?", "%#{query}%", "%#{query}%", "#{query}", "#{query}", "%#{query}%")
  end

  def assign_remaining_entries_to_ulrich_appel 
    super_admin = User.find_by_email('ulrich.apel@uni-tuebingen.de')
    super_admin.entries << self.entries
  end
end
