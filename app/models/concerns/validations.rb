module Validations
  extend ActiveSupport::Concern
  included do
    validates :kennzahl, presence: true
    validate :group_lemma_schreibungen_und_aussprachen
    validate :group_uebersetzungen_quellenangaben_literatur_und_ergaenzungen
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
        'muss ausgefüllt sein!'
    end
  end
end
