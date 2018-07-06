module ApplicationHelper
  def full_title(page_title = '')
    base_title = "Comunidad de vecinos"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, request.parameters.merge({:sort => column, :direction => direction, page: nil}), { :class => css_class }
  end

  def m_sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_movement_column ? "current #{sort_direction}" : nil
    direction = column == sort_movement_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, request.parameters.merge({:sort => column, :direction => direction, page: nil}), { :class => css_class }
  end
end
