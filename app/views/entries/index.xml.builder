xml.instruct!
xml.entries do
  @entries.each do |entry|
    xml.entry do
      xml.Id entry.id
      xml.kennzahl entry.kennzahl
      xml.uebersetzung entry.modify_ck_editor_tags
    end
  end

end
