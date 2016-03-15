require 'spec_helper'

describe Entry do

  it "has a valid factory" do
    expect(FactoryGirl.create(:entry)).to be_valid
  end

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
  it "raises an error if no field of the group lemma_schreibungen_und_aussprachen is filled out" do
    @entry.japanische_umschrift = ""
    expect(@entry.valid?).to be(false)
    expect(@entry.errors.messages[:base].first).to eq('Lemma-Schreibungen und -Aussprachen')
  end
  it "passes the test if at least on field of the group lemma_schreibungen_und_aussprachen is filled out" do
    @entry.japanische_umschrift = ""
    @entry.kanji = "kanji"
    expect(@entry.valid?).to be(true)
  end
  it "raises an error if no field of the group uebersetzungen_quellenangaben_literatur_und_ergaenzungen is filled out" do
    @entry.deutsche_uebersetzung = ""
    expect(@entry.valid?).to be(false)
    expect(@entry.errors.messages[:base].first).to eq('Uebersetzungen , Quellenangaben, Literatur und Ergaenzungen')
  end
  it "passes the thes if at least one field of the group uebersetzungen_quellenangaben_literatur_und_ergaenzungen is filled out" do
    @entry.deutsche_uebersetzung = ""
    @entry.uebersetzung = "fernfahrer"
    expect(@entry.valid?).to be(true)
  end
end
