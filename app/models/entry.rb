class Entry < ActiveRecord::Base
  require 'csv'
  has_paper_trail

  ALLOWED_PARAMS = [:namenskuerzel, :kennzahl, :spaltenzahl, :japanische_umschrift, :japanische_umschrift_din, 
                    :kanji, :pali, :sanskrit, :chinesisch, :tibetisch, :koreanisch, :weitere_sprachen, 
                    :alternative_japanische_lesungen, :schreibvarianten, :deutsche_uebersetzung, 
                    :lemma_art, :jahreszahlen, :uebersetzung, :quellen, :literatur, :eigene_ergaenzungen, 
                    :quellen_ergaenzungen, :literatur_ergaenzungen, :page_reference, :romaji_order, 
                    :lemma_in_katakana, :lemma_in_lateinbuchstaben, :user_id]

  belongs_to :user
  has_many :comments
  has_many :entry_docs
  has_many :entry_htmls

  validates :kennzahl, presence: true
  validate :group_lemma_schreibungen_und_aussprachen
  validate :group_uebersetzungen_quellenangaben_literatur_und_ergaenzungen

  before_save :cleanup

  scope :published, -> { where( freigeschaltet: true ) }


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
 def group_lemma_schreibungen_und_aussprachen
   if self.japanische_umschrift.blank? && self.kanji.blank? && self.chinesisch.blank? && self.tibetisch.blank? && self.koreanisch.blank? && self.pali.blank? && self.sanskrit.blank? && self.weitere_sprachen.blank? && self.alternative_japanische_lesungen.blank? && self.schreibvarianten.blank? 
      self.errors[:base] = "Mindestens ein Feld der Kategorie 'Lemma-Schreibungen und -Aussprachen' muss ausgefüllt sein!"
    end
  end
 def group_uebersetzungen_quellenangaben_literatur_und_ergaenzungen
   if self.deutsche_uebersetzung.blank? && self.uebersetzung.blank? && self.quellen.blank? && self.literatur.blank? && self.eigene_ergaenzungen.blank? && self.quellen_ergaenzungen.blank? && self.literatur_ergaenzungen.blank? 
     self.errors[:base] = "Mindestens ein Feld der Kategorie 'Uebersetzungen , Quellenangaben, Literatur und Ergaenzungen' muss ausgefüllt sein!"
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
