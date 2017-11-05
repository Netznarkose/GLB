module Export
require 'builder'
require 'csv'

  def customized_xml(all_entries)
    xml = ::Builder::XmlMarkup.new( :indent => 2 )
    xml.entries do
      all_entries.each do |entry|
        xml.entry do
          entry.attributes.each do |attr_name, attr_value|
            if attr_name == 'uebersetzung'
              xml.uebersetzung { xml << modify_ck_editor_tags(entry) }
            else
              xml.tag!(attr_name, attr_value)
            end
          end
        end
      end
    end
  end

  def modify_ck_editor_tags(entry)
    doc = Nokogiri::HTML.fragment(entry.uebersetzung)
    doc.css("span").map do |span|
      span.name = span.attributes['class'].value # gibt dem span tag den namen des values
      span.attributes['class'].remove # löscht den value
    end
    doc.to_xml
  end

  def customized_csv(all_entries)
    column_names = all_entries.first.attributes.keys
    CSV.generate(:col_sep=>"\t", :quote_char => '"') do |csv|
      csv << column_names
      all_entries.each do |entry|
        csv << entry.attributes.values_at(*column_names)
      end
    end
  end
end
