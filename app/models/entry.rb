# namenskuerzel  # Short name version
# kennzahl  # Index number
# spaltenzahl  # Number of columns
# japanische_umschrift  # Japanese transliteration
# kanji  # Current word dictionary form
# pali  # Pali Transliteration
# sanskrit  # Sanscrit Transliteration
# chinesisch  # Chinese Transliteration
# tibetisch
# koreanisch
# weitere_sprachen  # Other languages
# alternative_japanische_lesungen  # Alternative Japanese Readings
# schreibvarianten  # Spellings variations
# deutsche_uebersetzung  # German Translations
# lemma_art  # Dictionary Entry Type
# jahreszahlen  # Date
# uebersetzung  # Translation
# quellen  # Sources
# literatur  # Literature
# eigene_ergaenzungen  # Own Additions
# quellen_ergaenzungen  # Additions from sources
# literatur_ergaenzungen  # Additions from literature
# page_reference
# freigeschaltet                   default: false # Published
# romaji_order

class Entry < ActiveRecord::Base
  require 'csv'
  has_paper_trail

  ALLOWED_PARAMS = [:namenskuerzel, :kennzahl, :spaltenzahl, :japanische_umschrift, :kanji, :pali, :sanskrit, :chinesisch, :tibetisch, :koreanisch, :weitere_sprachen, :alternative_japanische_lesungen, :schreibvarianten, :deutsche_uebersetzung, :lemma_art, :jahreszahlen, :uebersetzung, :quellen, :literatur, :eigene_ergaenzungen, :quellen_ergaenzungen, :literatur_ergaenzungen, :page_reference, :romaji_order, :user_id]

  belongs_to :user
  has_many :comments
  has_many :entry_docs
  has_many :entry_htmls

  validates :kennzahl, presence: true
  validate :user_is_allowed

  before_save :cleanup

  scope :published, -> { where( freigeschaltet: true ) }
  scope :by_user, ->(user) { where(user_id: user.id) }

  def self.search(query)
    if query 
      Entry.where("japanische_umschrift LIKE ? OR kanji LIKE ? OR namenskuerzel = ? OR kennzahl = ? OR romaji_order LIKE ? OR uebersetzung LIKE ?", "%#{query}%", "%#{query}%", "#{query}", "#{query}", "%#{query}%", "%#{query}%")
    end
  end

  def cleanup
    substituter = Substituter.new
    if self.japanische_umschrift
      self.romaji_order = substituter.substitute(self.japanische_umschrift).downcase
    end
  end

  private

  def user_is_allowed
    unless User.allowed_for_entries.where(id: self.user_id).any?
      errors.add( :user_id ,  "User is not allowed to create entry")
    end
  end
  def self.to_csv
    CSV.generate(:col_sep=>"\t", :quote_char => '"') do |csv|
      csv << column_names
      Entry.find_each(batch_size: 500) do |entry|
        csv << entry.attributes.values_at(*column_names)
      end
    end
  end
end
