
require 'spec_helper'

describe 'DSGVO' do

  it 'Guest get redirected to DSGVO-Manifest first' do
    visit root_path
    expect(page.find('h1').text).to eq('Allgemeine Datenschutzerklärung')
  end
end
