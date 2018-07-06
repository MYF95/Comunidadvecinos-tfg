class ApartmentsController < ApplicationController
  helper_method :sort_column, :sort_direction, :sort_pending_payment_column, :sort_movement_column, :sort_user_column
  before_action :logged_in_user
  before_action :apartment_getter, except: [:index, :new, :create]
  before_action :permissions, except: [:index, :show]
  before_action :balance_checker, except: [:index, :new, :create]

  def index
    @apartments = Apartment.order(sort_column + " " + sort_direction).paginate(per_page: 3, page: params[:page])
  end

  def new
    @apartment = Apartment.new
  end

  def create
    @apartment = Apartment.new(apartment_params)
    if total_apartment_contribution(@apartment) > 1
      @apartment.update_attribute(:apartment_contribution, 0)
      if @apartment.save
        flash[:info] ="La vivienda #{full_name_apartment(@apartment)} ha sido creada, pero la contribución de la cuota supera el máximo de la comunidad. Por favor, actualiza el valor de la contribución."
        redirect_to edit_apartment_path(@apartment)
      else
        flash[:danger] = 'Ha ocurrido un error en el sistema, por favor, vuelva a intentarlo.'
        render 'new'
      end
    else
      if @apartment.save
        flash[:info] = "¡Nueva vivienda #{full_name_apartment(@apartment)} creada!"
        redirect_to @apartment
      else
        flash[:danger] = 'Ha ocurrido un error en el sistema, por favor, vuelva a intentarlo.'
        render 'new'
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    if total_apartment_contribution(@apartment) > 1
      @apartment.update_attribute(:apartment_contribution, 0)
      flash[:danger] = "La contribución que intentas poner en la vivienda #{full_name_apartment(@apartment)} supera el máximo."
      redirect_to edit_apartment_path(@apartment)
    else
      if Apartment.where(floor: params[:apartment][:floor].to_i, letter: params[:apartment][:letter].capitalize).empty?
        if @apartment.update_attributes(apartment_params)
          flash[:info] = 'Vivienda actualizada'
          redirect_to @apartment
        else
          render 'edit'
        end
      else
        flash[:danger] = "Ya hay una vivienda con ese piso y letra, elige otro."
        render 'edit'
      end
    end
  end

  def destroy
    if @apartment.destroy
      flash[:info] = 'Vivienda borrada'
      redirect_to apartments_path
    else
      redirect_to root_url
    end
  end

  # User related actions

  def users
    @users = @apartment.users.order(sort_user_column + " " + sort_direction).paginate(per_page: 5, page: params[:page])
  end

  def add_user
    @user = User.find(params[:user_id])
    @user_apartment = UserApartment.find_by(user: @user, apartment: @apartment)
    if @user_apartment.nil?
      create_user_apartment
    else
      flash[:danger] = 'El usuario ya está en la vivienda'
      redirect_to @apartment
    end
  end

  def remove_user
    @user = User.find(params[:user_id])
    if @apartment.owner == @user
      flash[:danger] = 'El usuario que intentas quitar es el propietario. Desasígnalo como propietario antes de quitarlo de la vivienda,'
      redirect_to apartment_users_path(@apartment)
      return
    end
    @userapartment = UserApartment.find_by(user: @user, apartment: @apartment)
    if @userapartment.blank?
      flash[:danger] = "#{@user.first_name} no está en la vivienda"
      redirect_to @apartment
    else
      if @userapartment.destroy
        flash[:info] = "#{@user.first_name} ha sido quitado de la vivienda"
      else
        flash[:danger] = 'Hubo un problema quitando el usuario de la vivienda'
      end
      redirect_to @apartment
    end
  end

  def add_owner
    @user = User.find(params[:user_id])
    if @apartment.owner.nil?
      @apartment_owner = ApartmentOwner.new(apartment_id: @apartment.id, user_id: @user.id)
      if @apartment_owner.save
        @user_apartment = UserApartment.find_by(user: @user, apartment: @apartment)
        if @user_apartment.nil?
          create_user_apartment
        else
          flash[:info] = 'El usuario ya estaba en la vivienda y se ha añadido como propietario.'
          redirect_to @apartment
        end
      else
        flash[:danger] = 'Hubo un problema asignando al usuario como propietario de la vivienda'
        redirect_to apartment_users_path(@apartment)
      end
    else
      flash[:danger] = 'La vivienda ya tiene un propietario. Si quieres cambiar de propietario a la vivienda, desasocia el propietario primero para asegurar que quieres realizar la acción.'
      redirect_to apartment_users_path(@apartment)
    end
  end

  def remove_owner
    owner = @apartment.owner
    if @apartment.apartment_owner.destroy
      flash[:info] = "Se ha quitado a #{owner.first_name} como propietario de la vivienda."
    else
      flash[:danger] = 'Ha ocurrido un problema al intentar desasociar el propietario de la vivienda'
    end
    redirect_to @apartment
  end

  # Movement related actions

  def movements
    @movements = @apartment.movements.order(sort_movement_column + " " + sort_direction).paginate(per_page: 5, page: params[:page])
  end

  # Pending Payments related actions

  def history
    @pending_payments = @apartment.pending_payments.order(sort_pending_payment_column + " " + sort_direction).paginate(per_page: 7, page: params[:page])
  end

  def pending_payments
    @pending_payments = @apartment.pending_payments.order(sort_pending_payment_column + " " + sort_direction).paginate(per_page: 7, page: params[:page])
  end

  def pending_payments_users
    @pending_payment = PendingPayment.find(params[:pending_payment_id])
  end

  def pay_pending_payment
    @user = User.find(params[:user_id])
    @pendingpayment = PendingPayment.find(params[:pending_payment_id])
    oldest_pending_payment = @apartment.pending_payments.where(paid: false).order('date asc').first
    if @pendingpayment == oldest_pending_payment
      if @apartment.balance >= @pendingpayment.amount
        if @pendingpayment.update_attributes(paid: true, paid_by: full_name(@user))
          flash[:info] = "Se ha pagado el pago pendiente '#{@pendingpayment.concept}'"
          redirect_to apartment_path(@apartment)
        else
          flash[:danger] = 'Ha ocurrido un error a la hora de pagar el pago pendiente'
        end
      else
        flash[:danger] = "La vivienda #{full_name_apartment(@apartment)} no tiene suficiente saldo para pagar el pago pendiente"
        redirect_to apartment_pending_payments_path(@apartment)
      end
    else
      flash[:danger] = "El pago pendiente que intentas pagar no es el más antiguo de la vivienda. Por favor, paga primero '#{oldest_pending_payment.concept}'"
      redirect_to apartment_pending_payments_path(@apartment)
    end
  end

  private

    def sort_column
      Apartment.column_names.include?(params[:sort]) ? params[:sort] : "floor"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    def sort_pending_payment_column
      PendingPayment.column_names.include?(params[:sort]) ? params[:sort] : "date"
    end

    def sort_movement_column
      Movement.column_names.include?(params[:sort]) ? params[:sort] : "concept"
    end

    def sort_user_column
      User.column_names.include?(params[:sort]) ? params[:sort] : "first_name"
    end

    def apartment_getter
      @apartment = Apartment.find(params[:id])
    end

    def apartment_params
      params.require(:apartment).permit(:owner, :floor, :letter, :fee, :balance, :apartment_contribution)
    end

    def permissions
      unless current_user.admin?
        flash[:danger] = 'Tu cuenta no tiene permisos para realizar esa acción. Por favor, contacta con el administrador para más información.'
        redirect_to root_path
      end
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

    def create_user_apartment
      @user_apartment = UserApartment.new(user: @user, apartment: @apartment)
      if @user_apartment.save!
        flash[:info] = "#{@user.first_name} añadido a la vivienda"
        redirect_to apartment_users_path(@apartment)
      else
        flash[:danger] = 'Hubo un error al añadir el usuario a la vivienda'
        redirect_to @apartment
      end
    end
end
