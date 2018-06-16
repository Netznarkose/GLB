module Params
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
end
