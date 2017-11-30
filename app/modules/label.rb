module Label

  def formatted?
    /<("[^"]*"|'[^']*'|[^'">])*>/ === uebersetzung.to_s.gsub('<p>', '').gsub('</p>', '')
  end

  def unformatted?
    if formatted? || unprocessed?
      false
    else
      true
    end
  end

  def unprocessed?
    leer_or_nil? || basic_identifier?
  end

  def leer_or_nil?
    uebersetzung.blank? || uebersetzung.casecmp('leer').zero? || /<p>leer<\/p>/ === uebersetzung.downcase
  end

  def basic_identifier?
    /Lemma/ === uebersetzung[0..38] && /SBDJ/ === uebersetzung[0..38]
  end
end
