require 'spec_helper'

RSpec.describe EntriesHelper, type: :helper do
  describe '#ignore_numbers_after_colon' do
    it 'ignores numbers after colon' do
      expect(ignore_numbers_after_colon('29:3')).to eq(29)
      expect(ignore_numbers_after_colon('3')).to eq(3)
      expect(ignore_numbers_after_colon('14:52')).to eq(14)
    end
  end
  describe '#to_four_digits' do
    it 'prepends zeros if number is smaller then 1000' do
      expect(to_four_digits(5)).to eq('0005')
      expect(to_four_digits(888)).to eq('0888')
    end
  end

  describe '#build_url' do
    it 'returns valid url' do
      expect(build_url([0, '_oben'], 7)).to eq('http://buddhismus-lexikon.eu:/SBDJ-Original-JPGs/Lex_0007_oben.jpg')
    end
  end
  describe '#embed_scans' do
    it 'returns an array of valid image_params' do
      expect(embed_scans('7')).to eq([
                                              {
                                                url:   'http://buddhismus-lexikon.eu:/SBDJ-Original-JPGs/Lex_0007_oben.jpg',
                                                style: 'display: block',
                                                id:    'page0',
                                                size:  '760x400'
                                              },
                                              {
                                                url:   'http://buddhismus-lexikon.eu:/SBDJ-Original-JPGs/Lex_0007_mitten.jpg',
                                                style: 'display: none',
                                                id:    'page1',
                                                size:  '760x400'
                                              },
                                              {
                                                url:   'http://buddhismus-lexikon.eu:/SBDJ-Original-JPGs/Lex_0007_unten.jpg',
                                                style: 'display: none',
                                                id:    'page2',
                                                size:  '760x400'
                                              },
                                              {
                                                url:   'http://buddhismus-lexikon.eu:/SBDJ-Original-JPGs/Lex_0008_oben.jpg',
                                                style: 'display: none',
                                                id:    'page3',
                                                size:  '760x400'
                                              },
                                              {
                                                url:   'http://buddhismus-lexikon.eu:/SBDJ-Original-JPGs/Lex_0008_mitten.jpg',
                                                style: 'display: none',
                                                id:    'page4',
                                                size:  '760x400'
                                              },
                                              {
                                                url:   'http://buddhismus-lexikon.eu:/SBDJ-Original-JPGs/Lex_0008_unten.jpg',
                                                style: 'display: none',
                                                id:    'page5',
                                                size:  '760x400'
                                              },
                                              {
                                                url:   'http://buddhismus-lexikon.eu:/SBDJ-Original-JPGs/Lex_0009_oben.jpg',
                                                style: 'display: none',
                                                id:    'page6',
                                                size:  '760x400'
                                              },
                                              {
                                                url:   'http://buddhismus-lexikon.eu:/SBDJ-Original-JPGs/Lex_0009_mitten.jpg',
                                                style: 'display: none',
                                                id:    'page7',
                                                size:  '760x400'
                                              },
                                              {
                                                url:   'http://buddhismus-lexikon.eu:/SBDJ-Original-JPGs/Lex_0009_unten.jpg',
                                                style: 'display: none',
                                                id:    'page8',
                                                size:  '760x400'
                                              }
                                            ])
    end
  end
end
