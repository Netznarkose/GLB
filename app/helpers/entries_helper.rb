if ENV['RAILS_ENV'] == 'development'
  require 'pry-byebug'
end

module EntriesHelper
  def embed_scans(kennzahl)
    [
      [0, '_oben'],
      [0, '_mitten'],
      [0, '_unten'],
      [1, '_oben'],
      [1, '_mitten'],
      [1, '_unten'],
      [2, '_oben'],
      [2, '_mitten'],
      [2, '_unten']
    ].each_with_index.map do |page_number_and_location, index|
      image_params(index, page_number_and_location, ignore_numbers_after_colon(kennzahl))
    end
  end

  def sanskrit_special_chars
    ['Ā', 'ā', 'Æ', 'æ', 'Ǣ', 'ǣ', 'Ē', 'ē', 'Ī', 'ī', 'Ō', 'ō', 'Ū', 'ū', 'Ḍ', 'ḍ', 'Ġ', 'ġ', 'Ḥ', 'ḥ', 'Ḷ', 'ḷ', 'Ḹ', 'ḹ', 'Ṃ', 'ṃ', 'Ṁ', 'ṁ', 'Ṇ', 'ṇ', 'Ṅ', 'ṅ', 'Ñ', 'ñ', 'Ṛ', 'ṛ', 'Ṝ', 'ṝ', 'Ś', 'ś', 'Ṣ', 'ṣ', 'Ṭ', 'ṭ']
  end

  def label_status(status)
    case status
    when 'Code veraltet'
      'label label-warning'
    when 'unbearbeitet'
      'label label-danger'
    when 'unformatiert'
      'label label-info'
    when 'formatiert'
      'label label-success'
    end
  end

  def all_fields
    (['all'] + Entry::STATUS + Entry.column_names).map do |entry|
      if entry == 'all'
        ['Alle Felder', 'all']
      else
        [entry.capitalize, entry]
      end
    end
  end

  def selected_field
    if params[:field_select]
      field_select = params[:field_select]
      [field_select.capitalize, field_select]
    end
  end

  private

  def ignore_numbers_after_colon(kennzahl)
    kennzahl.split(':')[0].to_i
  end

  def image_params(index, page_number_and_location, kennzahl)
    {
      url:   build_url(page_number_and_location, kennzahl),
      style: index == 0 ? 'display: block' : 'display: none',
      id:    "page#{index}",
      size:  '760x400'
    }
  end

  def build_url(page_number_and_location, kennzahl)
    page     = kennzahl + page_number_and_location.first
    location = page_number_and_location.last
    "http://buddhismus-lexikon.eu:/SBDJ-Original-JPGs/Lex_#{to_four_digits(page)}#{location}.jpg"
  end

  def to_four_digits(page)
    page = page.to_s
    (4 - page.length).times { page.prepend('0') } if page.length < 4
    page
  end
end
