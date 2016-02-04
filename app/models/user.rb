class User < ActiveRecord::Base
  # has_many :entries, dependent: :destroy
  # has_many :entries, dependent: { user_id: 1 }
  has_many :entries
  has_many :comments
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true
  validates :email, presence: true

  scope :allowed_for_entries, ->{ where( role: ['admin', 'editor']) }


  def admin?
    role == "admin"
  end

  def editor?
    role == "editor"
  end

  def search_entries(query)
    self.entries.where("japanische_umschrift LIKE ? OR kanji LIKE ? OR namenskuerzel = ? OR kennzahl = ? OR romaji_order LIKE ?", "%#{query}%", "%#{query}%", "#{query}", "#{query}", "%#{query}%")
  end

  def assign_remaining_entries_to_user_one 
    Entry.where(user_id: nil).map do |entry|
      entry.user_id = 1 
      entry.save
    end
  end


end
