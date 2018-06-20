class ApartmentsController < ApplicationController
  #TODO make this options available only to Admin

  def index
    @apartments = Apartment.all
  end

  def new
    @apartment = Apartment.new
  end

  def create
    @apartment = Apartment.new(apartment_params)
    if @apartment.save
      flash[:info] = "Nueva vivienda #{@apartment.floor}º#{@apartment.letter} created!"
      redirect_to @apartment
    else
      flash[:error] = 'Ha ocurrido un error en el sistema, por favor, vuelva a intentarlo.'
      render 'new'
    end
  end

  def show
    @apartment = Apartment.find(params[:id])
  end

  def edit
  end

  def destroy
  end

  private

    def apartment_params
      params.require(:apartment).permit(:owner, :floor, :letter, :fee, :balance)
    end

end
