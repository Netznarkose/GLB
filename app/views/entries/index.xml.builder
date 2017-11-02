file = File.new("my_xml_data_file.xml", "wb")
xml = Builder::XmlMarkup.new target: file
xml.entries do
  @entries.each do |entry|
    xml.entry do
      xml.Id entry.id
      xml.kennzahl entry.kennzahl
      xml.uebersetzung entry.modify_ck_editor_tags
    end
  end

end
file.close
