class Entry < ActiveRecord::Base
  require 'builder'
  require 'csv'
  has_paper_trail

  ALLOWED_PARAMS = [:namenskuerzel, :kennzahl,
                    :spaltenzahl, :japanische_umschrift,
                    :japanische_umschrift_din,
                    :kanji, :pali, :sanskrit,
                    :chinesisch, :tibetisch,
                    :koreanisch, :weitere_sprachen,
                    :alternative_japanische_lesungen,
                    :schreibvarianten, :deutsche_uebersetzung,
                    :lemma_art, :jahreszahlen,
                    :uebersetzung, :quellen, :literatur,
                    :eigene_ergaenzungen, :quellen_ergaenzungen,
                    :literatur_ergaenzungen, :page_reference,
                    :romaji_order, :lemma_in_katakana,
                    :lemma_in_lateinbuchstaben, :user_id,
                    :freigeschaltet, :abweichende_kennzahl,
                    :japanischer_quelltext,
                    :japanischer_quelltext_bearbeitungsstand,
                    :seite_textblock2005]

  belongs_to :user
  has_many :comments
  has_many :entry_docs
  has_many :entry_htmls

  validates :kennzahl, presence: true
  validate :group_lemma_schreibungen_und_aussprachen
  validate :group_uebersetzungen_quellenangaben_literatur_und_ergaenzungen

  before_save :cleanup

  scope :published, -> { where(freigeschaltet: true) }

  def self.search(query)
    if query
      Entry.where("japanische_umschrift LIKE ? OR
        kanji LIKE ? OR
        namenskuerzel = ? OR
        kennzahl = ? OR
        romaji_order LIKE ? OR
        jahreszahlen LIKE ? OR
        uebersetzung LIKE ?",
        "%#{query}%","%#{query}%", "%#{query}%", "#{query}", "#{query}", "%#{query}%", "%#{query}%")
    end
  end

  def modify_ck_editor_tags
    doc = Nokogiri::HTML.fragment(self.uebersetzung)
    doc.css("span").map do |span|
      span.name = span.attributes['class'].value # gibt dem span tag den namen des values
      span.attributes['class'].remove # löscht den value
    end
    doc.to_xml
  end

  def cleanup
    substituter = Substituter.new
    if self.japanische_umschrift
      self.romaji_order = substituter.substitute(self.japanische_umschrift).downcase
    end
  end

  def group_lemma_schreibungen_und_aussprachen
    if japanische_umschrift.blank? &&
        kanji.blank? &&
        chinesisch.blank? &&
        tibetisch.blank? &&
        koreanisch.blank? &&
        pali.blank? &&
        sanskrit.blank? &&
        weitere_sprachen.blank? &&
        alternative_japanische_lesungen.blank? &&
        schreibvarianten.blank?
      errors[:base] = 'Mindestens ein Feld der Gruppe '\
        "'Lemma-Schreibungen und -Aussprachen' muss ausgefüllt sein!"
    end
  end

  def group_uebersetzungen_quellenangaben_literatur_und_ergaenzungen
    if deutsche_uebersetzung.blank? &&
        uebersetzung.blank? &&
        quellen.blank? &&
        literatur.blank? &&
        eigene_ergaenzungen.blank? &&
        quellen_ergaenzungen.blank? &&
        literatur_ergaenzungen.blank?
      errors[:base] = 'Mindestens ein Feld der Gruppe '\
        "'Uebersetzungen , Quellenangaben, Literatur und Ergaenzungen' "\
        "muss ausgefüllt sein!"
    end
  end


  private

  def self.to_csv
    CSV.generate(:col_sep=>"\t", :quote_char => '"') do |csv|
      csv << column_names
      Entry.find_each(batch_size: 500) do |entry|
        csv << entry.attributes.values_at(*column_names)
      end
    end
  end

  def self.to_customized_xml
    xml = ::Builder::XmlMarkup.new( :indent => 2 )
    xml.entries do
      Entry.all.each do |entry|
        xml.entry do
          xml.namenskuerzel entry.namenskuerzel
          xml.kennzahl entry.kennzahl
          xml.spaltenzahl entry.spaltenzahl
          xml.japanische_umschrift entry.japanische_umschrift
          xml.kanji entry.kanji
          xml.pali entry. pali
          xml.sanskrit entry.sanskrit
          xml.chinesisch entry.chinesisch
          xml.tibetisch entry.tibetisch
          xml.koreanisch entry.koreanisch
          xml.weitere_sprachen entry.weitere_sprachen
          xml.alternative_japanische_lesungen entry.alternative_japanische_lesungen
          xml.schreibvarianten entry.schreibvarianten
          xml.deutsche_uebersetzung entry.deutsche_uebersetzung
          xml.lemma_art entry.lemma_art
          xml.jahreszahlen entry.jahreszahlen
          xml.uebersetzung do
            xml << entry.modify_ck_editor_tags
          end
          xml.quellen entry.quellen
          xml.literatur entry.literatur
          xml.eigene_ergaenzungen entry.eigene_ergaenzungen
          xml.quellen_ergaenzungen entry.quellen_ergaenzungen
          xml.literatur_ergaenzungen entry.literatur_ergaenzungen
          xml.user_id entry.user_id
          xml.page_reference entry.page_reference
          xml.freigeschaltet entry.freigeschaltet
          xml.romaji_order entry.romaji_order
          xml.japanische_umschrift_din entry.japanische_umschrift_din
          xml.lemma_in_katakana entry.lemma_in_katakana
          xml.lemma_in_lateinbuchstaben entry.lemma_in_lateinbuchstaben
          xml.abweichende_kennzahl entry.abweichende_kennzahl
          xml.japanischer_quelltext entry.japanischer_quelltext
          xml.japanischer_quelltext_bearbeitungsstand entry.japanischer_quelltext_bearbeitungsstand
          xml.seite_textblock2005 entry.seite_textblock2005
        end
      end
    end
  end
end











