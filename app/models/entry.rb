class Entry < ActiveRecord::Base
  has_paper_trail
  belongs_to :user
  has_many :comments
  has_many :entry_docs
  has_many :entry_htmls
  attr_accessible :alternative_japanische_lesungen, :chinesisch, :deutsche_uebersetzung, :eigene_ergaenzungen, :jahreszahlen, :japanische_umschrift, :kanji, :kennzahl, :koreanisch, :lemma_art, :literatur, :literatur_ergaenzungen, :pali, :quellen, :quellen_ergaenzungen, :sanskrit, :schreibvarianten, :spaltenzahl, :tibetisch, :uebersetzung, :namenskuerzel, :weitere_sprachen, :freigeschaltet, :romaji_order

  validates :kennzahl, presence: true, kennzahl: true
  before_save :cleanup

  def self.search(query)
    Entry.where("japanische_umschrift LIKE ? OR kanji LIKE ? OR namenskuerzel = ? OR kennzahl = ?", "%#{query}%", "%#{query}%", "#{query}", "#{query}")
  end
  
  def cleanup
    substituter = Substituter.new
    if self.japanische_umschrift
      self.romaji_order = substituter.substitute(self.japanische_umschrift).downcase
    end
  end


end
