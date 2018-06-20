module ApartmentsHelper

  def fullname(apartment)
    "#{apartment.floor}º#{apartment.letter}"
  end

end
