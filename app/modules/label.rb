module Label
  def formatted?
    holds_html_tags? === strip_p_tags(uebersetzung)
  end

  def holds_html_tags?
    /<("[^"]*"|'[^']*'|[^'">])*>/
  end

  def strip_p_tags(field)
    field.to_s.gsub('<p>', '').gsub('</p>', '')
  end

  def deprecated_syntax?
    deprecated_syntax_chars.any? do |regex|
      regex === uebersetzung
    end
  end

  def deprecated_syntax_chars
    [
      /<p>&icirc;/,
      /&acirc;/,
      /--&amp;gt;/,
      /&ucirc;/,
      //,
      //,
      /\\C\\/,
      /\\J\\/,
      /\\S\\/,
      /\\P\\/,
      /\\K\\/,
      /\\T\\/,
      /\\C/,
      /\\J/,
      /\\S/,
      /\\P/,
      /\\K/,
      /\\T/,
      /~n/,
      /\^s/,
      /&amp;#39;/,
      /\^S/,
      /&amp;rarr;/,
      /--&gt;/
    ]
  end

  def unformatted?
    formatted? || unprocessed? || deprecated_syntax? ? false : true
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
