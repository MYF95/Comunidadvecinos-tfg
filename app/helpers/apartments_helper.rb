module ApartmentsHelper

  def full_name_apartment(apartment)
    "#{apartment.floor}º#{apartment.letter}"
  end

end
