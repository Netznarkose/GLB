module ApplicationHelper
  def sortable(column, title = nil, sort_direct = nil)
    title ||= column.titleize
    direction = sort_direct ? sort_direct : 'asc'
    link_to title, sort: column, direction: direction
  end
end
