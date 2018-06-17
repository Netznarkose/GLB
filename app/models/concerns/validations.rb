module Validations
  extend ActiveSupport::Concern
  included do
    validates :kennzahl, presence: true
    validate :group_lemma_schreibungen_und_aussprachen
    validate :group_uebersetzungen_quellenangaben_literatur_und_ergaenzungen
  end

  private
  
  def group_lemma_schreibungen_und_aussprachen
    unless [
      japanische_umschrift,
      kanji, chinesisch,
      tibetisch, koreanisch,
      pali,
      sanskrit,
      weitere_sprachen,
      alternative_japanische_lesungen,
      schreibvarianten
    ].any?(&:present?)
      errors.add(:japanische_umschrift, :blank) # why does it have to be an entry-field?
    end
  end

  def group_uebersetzungen_quellenangaben_literatur_und_ergaenzungen
    unless [
      deutsche_uebersetzung,
      uebersetzung,
      quellen,
      literatur,
      eigene_ergaenzungen,
      quellen_ergaenzungen,
      literatur_ergaenzungen
    ].any?(&:present?)
      errors.add(:deutsche_uebersetzung, :blank)
    end
  end
end
