class ApartmentsController < ApplicationController
  #TODO make this options available only to Admin
  before_action :apartment_getter, except: [:index, :new, :create]

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
  end

  def edit
  end

  #TODO Ver que hacer con los flash error

  def update
    if @apartment.update_attributes(apartment_params)
      flash[:info] = 'Vivienda actualizada'
      redirect_to @apartment
    else
      # flash[:danger] = 'No se ha podido actualizar la vivienda, vuelva a intentarlo.'
      render 'edit'
    end
  end

  def destroy
    if @apartment.destroy
      flash[:info] = 'Vivienda borrada'
      redirect_to apartments_path
    else
      # flash[:danger] = 'Ha habido un error en el sistema, por favor, vuelva a intentarlo.'
      redirect_to root_url
    end
  end

  private

    def apartment_getter
      @apartment = Apartment.find(params[:id])
    end

    def apartment_params
      params.require(:apartment).permit(:owner, :floor, :letter, :fee, :balance)
    end

end
