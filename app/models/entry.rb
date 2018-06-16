class Entry < ActiveRecord::Base
  include Label
  include Validations
  include Search
  has_paper_trail class_name: 'EntryVersion'

  belongs_to :user
  delegate :name, to: :user
  has_many :comments
  has_many :entry_docs
  has_many :entry_htmls

  before_save :cleanup
  before_destroy :destroy_related_assignment

  scope :published, -> { where(freigeschaltet: true) }

  ALLOWED_PARAMS = %i[namenskuerzel kennzahl
                      spaltenzahl japanische_umschrift
                      japanische_umschrift_din
                      kanji pali sanskrit
                      chinesisch tibetisch
                      koreanisch weitere_sprachen
                      alternative_japanische_lesungen
                      schreibvarianten deutsche_uebersetzung
                      lemma_art jahreszahlen
                      uebersetzung quellen literatur
                      eigene_ergaenzungen quellen_ergaenzungen
                      literatur_ergaenzungen page_reference
                      romaji_order lemma_in_katakana
                      lemma_in_lateinbuchstaben user_id
                      freigeschaltet abweichende_kennzahl
                      japanischer_quelltext
                      japanischer_quelltext_bearbeitungsstand
                      seite_textblock2005
                      status
                      bearbeitungsansatz
                      assign_to_user_id
                      assign_to_date].freeze
  STATUS = [
    'leer',
    'unformatiert',
    'unbearbeitet',
    'Code veraltet',
    'bereits formatiert',
    'formatiert',
    'geprüft',
    'revidiert',
    'korrigiert',
    'korrekturgelesen',
    'mit Index-Markierungen versehen'
  ].freeze

  def destroy_related_assignment
    related_assignment = Assignment.where(entry_id: self).first
    related_assignment.destroy unless related_assignment.blank?
  end

  def cleanup
    substituter = Substituter.new
    self.romaji_order = substituter.substitute(japanische_umschrift).downcase if japanische_umschrift
  end

  def assignment
    Assignment.find_by(entry_id: id)
  end
end
