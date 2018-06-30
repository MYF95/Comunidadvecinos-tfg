class ApartmentsController < ApplicationController
  before_action :logged_in_user
  before_action :apartment_getter, except: [:index, :new, :create]
  before_action :balance_checker, except: [:index, :new, :create]

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
      permissions
    end
  end

  def show
  end

  def edit
  end

  def update
    if current_user.admin
      if @apartment.update_attributes(apartment_params)
        flash[:info] = 'Vivienda actualizada'
        redirect_to @apartment
      else
        render 'edit'
      end
    else
      permissions
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
      permissions
    end
  end

  # User related actions

  def users
  end

  def add_user
    if current_user.admin
      @user = User.find(params[:user_id])
      @userapartment = UserApartment.find_by(user: @user, apartment: @apartment)
      if @userapartment.blank?
        @userapartment = UserApartment.new(user_id: @user.id, apartment_id: @apartment.id)
        if @userapartment.save!
          flash[:info] = "#{@user.first_name} añadido a la vivienda"
          redirect_to apartment_users_path(@apartment)
        else
          flash[:danger] = 'Hubo un error al añadir el usuario a la vivienda'
          redirect_to @apartment
        end
      else
        flash[:danger] = 'El usuario ya está en la vivienda'
        redirect_to @apartment
      end
    else
      permissions
    end
  end

  def remove_user
    if current_user.admin
      @user = User.find(params[:user_id])
      @userapartment = UserApartment.find_by(user: @user, apartment: @apartment)
      if @userapartment.blank?
        flash[:danger] = "#{@user.first_name} no está en la vivienda"
        redirect_to @apartment
      else
        if @userapartment.destroy
          flash[:info] = "#{@user.first_name} ha sido quitado de la vivienda"
          redirect_to @apartment
        else
          flash[:danger] = 'Hubo un problema quitando el usuario de la vivienda'
          redirect_to @apartment
        end
      end
    end
  end

  # Movement related actions

  def movements
  end

  # Pending Payments related actions

  def history
  end

  def pending_payments
  end

  def pay_pending_payment
    if current_user.admin
      @pendingpayment = PendingPayment.find(params[:pending_payment_id])
      if @apartment.balance >= @pendingpayment.amount
        if @pendingpayment.update_attribute(:paid, true)
          flash[:info] = "Se ha pagado el pago pendiente '#{@pendingpayment.concept}'"
          redirect_to apartment_pending_payments_path(@apartment)
        else
          flash[:danger] = 'Ha ocurrido un error a la hora de pagar el pago pendiente'
          redirect_to apartment_pending_payments_path(@apartment)
        end
      else
        flash[:danger] = "La vivienda #{full_name_apartment(@apartment)} no tiene suficiente saldo para pagar el pago pendiente"
        redirect_to apartment_pending_payments_path(@apartment)
      end
    else
      permissions
    end
  end

  private

    def apartment_getter
      @apartment = Apartment.find(params[:id])
    end

    def apartment_params
      params.require(:apartment).permit(:owner, :floor, :letter, :fee, :balance)
    end

    def permissions
      flash[:danger] = 'Tu cuenta no tiene permisos para realizar esa acción. Por favor, contacta con el administrador para más información.'
      redirect_to root_path
    end

    def balance_checker
      @apartment = Apartment.find(params[:id])
      balance = 0
      @apartment.movements.each do |movement|
        balance += movement.amount
      end
      @apartment.pending_payments.each do |pending_payment|
        balance -= pending_payment.amount if pending_payment.paid?
      end
      @apartment.update_attribute(:balance, balance)
    end
end
