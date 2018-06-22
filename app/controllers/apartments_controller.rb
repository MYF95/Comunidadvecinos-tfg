class ApartmentsController < ApplicationController
  #TODO make this options available only to Admin
  before_action :logged_in_user, only: [:create, :destroy, :update]
  before_action :apartment_getter, except: [:index, :new, :create]

  def index
    @apartments = Apartment.all
  end

  def new
    @apartment = Apartment.new
  end

  def create
    if current_user.admin?
      @apartment = Apartment.new(apartment_params)
      if @apartment.save
        flash[:info] = "¡Nueva vivienda #{@apartment.floor}º#{@apartment.letter} creada!"
        redirect_to @apartment
      else
        flash[:danger] = 'Ha ocurrido un error en el sistema, por favor, vuelva a intentarlo.'
        render 'new'
      end
    else
      flash[:danger] = 'Tu cuenta no tiene permisos para realizar esa acción. Por favor, contacta con el administrador para más información.'
      redirect_to root_path
    end
  end

  def show
  end

  def edit
  end

  #TODO Flash errors in spanish

  def update
    if current_user.admin
      if @apartment.update_attributes(apartment_params)
        flash[:info] = 'Vivienda actualizada'
        redirect_to @apartment
      else
        render 'edit'
      end
    else
      flash[:danger] = 'Tu cuenta no tiene permisos para realizar esa acción. Por favor, contacta con el administrador para más información.'
      redirect_to root_path
    end
  end

  def destroy
    if current_user.admin
      if @apartment.destroy
        flash[:info] = 'Vivienda borrada'
        redirect_to apartments_path
      else
        redirect_to root_url
      end
    else
      flash[:danger] = 'Tu cuenta no tiene permisos para realizar esa acción. Por favor, contacta con el administrador para más información.'
      redirect_to root_path
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
