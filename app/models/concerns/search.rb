module Search
  extend ActiveSupport::Concern

  class_methods do
    def search(column = 'all', query)
      column.eql?('all') ? all_columns(query) : single_column(column, query)
    end

    def all_columns(query)
      if query
        Entry.where("japanische_umschrift LIKE ? OR
          kanji LIKE ? OR
          namenskuerzel = ? OR
          kennzahl = ? OR
          romaji_order LIKE ? OR
          jahreszahlen LIKE ? OR
          uebersetzung LIKE ?",
          "%#{query}%","%#{query}%", "%#{query}%", "#{query}", "#{query}", "%#{query}%", "%#{query}%")
        end
      end

      def single_column(column, query)
        if Entry::BEARBEITUNGS_STAND.include?(column)
          Entry.where(bearbeitungsstand: column).where('japanische_umschrift LIKE ?', "#{query}%")
        else
          Entry.where("#{column} LIKE ?", "%#{query}%")
        end
      end
    end
  end
