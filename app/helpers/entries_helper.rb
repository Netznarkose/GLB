module EntriesHelper
  #The next page should be linked too. REASON: dictionary entry could be on 2 or even more pages...
  #I am not paid enough for preventing error triggered by non-existing 2. page!
  def to_scan_pages kennzahl
    page = kennzahl.split(":")[0].to_i #avoid error for kennzahl with 0 at the beginning
    [to_scan_pages_helper(page), to_scan_pages_helper(page + 1), to_scan_pages_helper(page + 2), to_scan_pages_helper(page + 3), to_scan_pages_helper(page + 4), to_scan_pages_helper(page + 5), to_scan_pages_helper(page + 6), to_scan_pages_helper(page + 7)]
  end

  def sanskrit_special_chars
    %w{Ā ā Æ æ Ǣ ǣ Ē ē Ī ī Ō ō Ū ū Ḍ ḍ Ġ ġ Ḥ ḥ Ḷ ḷ Ḹ ḹ Ṃ ṃ Ṁ ṁ Ṇ ṇ Ṅ ṅ Ñ ñ Ṛ ṛ Ṝ ṝ Ś ś Ṣ ṣ Ṭ ṭ}
  end

  def label_bearbeitungsstand(bearbeitungsstand)
    case bearbeitungsstand
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

  def entry_search_attributes
    all_fields = (['alle'] + Entry::BEARBEITUNGS_STAND + Entry.column_names)
    field_select = params[:field_select] if all_fields.include?(params[:field_select])
    a = all_fields.map do |entry|
      [entry.capitalize, entry]
    end
    unless field_select.blank?
      a.delete([field_select.capitalize, field_select])
      a.unshift([field_select.capitalize, field_select])
    end
    a
  end

  private
  # make digits that are smaller then four digit to for digit numbers
  # example 9 becomes 0009
  def to_scan_pages_helper page
    page = page.to_s
    if page.length < 4
      diff = 4 - page.length
      while diff > 0 do
        page = "0" + page
        diff -= 1
      end
    end
    page
  end
end
