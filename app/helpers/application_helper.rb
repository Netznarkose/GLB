module ApplicationHelper
  def sortable(column, title = nil, sort_me = nil)
    title ||= column.titleize
    # css_class = column == sort_column ? "current #{sort_direction}" : nil
    if sort_me
      direction = sort_me
    else
      direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    end
    link_to title, {:sort => column, :direction => direction}#, {:class => css_class}
  end
end
