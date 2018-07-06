module ApartmentsHelper

  def full_name_apartment(apartment)
    "#{apartment.floor}º#{apartment.letter.capitalize}"
  end

  def total_apartment_contribution(new_apartment)
    new_apartment.id.nil? ? @apartment_contribution = new_apartment.apartment_contribution : @apartment_contribution = 0
    Apartment.all.each do |apartment|
      unless apartment.apartment_contribution.nil?
        @apartment_contribution += apartment.apartment_contribution
      end
    end
    @apartment_contribution
  end

  def pp_sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_pending_payment_column ? "current #{sort_direction}" : nil
    direction = column == sort_pending_payment_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, request.parameters.merge({:sort => column, :direction => direction, page: nil}), { :class => css_class }
  end

  def u_sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_user_column ? "current #{sort_direction}" : nil
    direction = column == sort_user_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, request.parameters.merge({:sort => column, :direction => direction, page: nil}), { :class => css_class }
  end
end
