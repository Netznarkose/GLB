require 'spec_helper'

describe Entry do
  before do
    @entry = FactoryGirl.create :entry
  end
  it "should validate_presence_of :kennzahl" do
    @entry.kennzahl = nil
    expect(@entry.valid?).to be(false)
  end
  it "raises an error if kennzahl has the wrong format" do
    pending('tdd?')
    @entry.kennzahl = "1234"
    expect(@entry.valid?).to be(false)
  end
  it "raises an error if no field of the group 'Lemma-Schreibungen und -Aussprachen' is filled out" do
    @entry.japanische_umschrift = ""
    # @entry.japanische_umschrift_din = ""
    @entry.kanji = ""
    @entry.chinesisch = ""
    @entry.tibetisch = ""
    @entry.koreanisch = ""
    @entry.pali = ""
    @entry.sanskrit = ""
    @entry.weitere_sprachen = ""
    @entry.alternative_japanische_lesungen = ""
    @entry.schreibvarianten = ""
    # @entry.lemma_in_katakana = ""
    # @entry.lemma_in_lateinbuchstaben = ""
    expect(@entry.valid?).to be(false)
    expect(@entry.errors.messages[:base].first).to eq('Lemma-Schreibungen und -Aussprachen')
  end
  it "passes the test if at least on field of the group 'Lemma-Schreibungen und -Aussprachen' is filled out" do
    @entry.japanische_umschrift = ""
    # @entry.japanische_umschrift_din = ""
    @entry.kanji = ""
    @entry.chinesisch = ""
    @entry.tibetisch = ""
    @entry.koreanisch = "bruce lee"
    @entry.pali = ""
    @entry.sanskrit = "james bond"
    @entry.weitere_sprachen = ""
    @entry.alternative_japanische_lesungen = ""
    @entry.schreibvarianten = ""
    # @entry.lemma_in_katakana = ""
    # @entry.lemma_in_lateinbuchstaben = ""
    expect(@entry.valid?).to be(true)
  end
end
