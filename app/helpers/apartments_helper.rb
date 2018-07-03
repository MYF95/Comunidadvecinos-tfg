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
end
