class PendingPaymentsController < ApplicationController
  before_action :logged_in_user
  before_action :pending_payment_getter, except: [:index, :new, :create]

  def index
    @pending_payments = PendingPayment.all
  end

  def new
    @pending_payment = PendingPayment.new
    @apartments = Apartment.all
  end

  def create
    if current_user.admin?
      @pending_payment = PendingPayment.new(pending_payment_params)
      if @pending_payment.save
        flash[:info] = "¡Nuevo pago pendiente creado!"
        redirect_to @pending_payment
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

  def update
    if current_user.admin
      if @pending_payment.update_attributes(pending_payment_params)
        flash[:info] = 'Pago pendiente actualizada'
        redirect_to @pending_payment
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
      if @pending_payment.destroy
        flash[:info] = 'Pago pendiente borrado'
        redirect_to pending_payments_path
      else
        redirect_to root_path
      end
    else
      flash[:danger] = 'Tu cuenta no tiene permisos para realizar esa acción. Por favor, contacta con el administrador para más información.'
      redirect_to root_path
    end
  end

  def apartments
    @apartments = Apartment.all
  end

  def associate_apartment
    if current_user.admin
      @apartment = Apartment.find(params[:apartment_id])
      @apartmentpendingpayment = ApartmentPendingPayment.find_by(pending_payment: @pending_payment)
      if @apartmentpendingpayment.nil?
        @apartmentpendingpayment = ApartmentPendingPayment.new(apartment: @apartment, pending_payment: @pending_payment)
        if @apartmentpendingpayment.save
          flash[:info] = "Se ha asociado el pago pendiente a la vivienda #{full_name_apartment(@apartment)}"
          redirect_to pending_payments_path
        else
          flash[:danger] = 'Ha ocurrido un error al intentar crear la asociación del pago pendiente'
          redirect_to pending_payments_path
        end
      else
        if @apartmentpendingpayment.update_attribute(:apartment, @apartment)
          flash[:info] = "Se ha cambiado la asociación del pago pendiente a la vivienda #{full_name_apartment(@apartment)}"
          redirect_to pending_payments_path
        else
          flash[:danger] = 'Ha ocurrido un error al intentar cambiar la asociación del pago pendiente'
          redirect_to pending_payments_path
        end
      end
    else
      permissions
    end
  end

  private

  def pending_payment_getter
    @pending_payment = PendingPayment.find(params[:id])
  end

  def pending_payment_params
    params.require(:pending_payment).permit(:concept, :date, :amount, :description, :paid, :apartments)
  end
end
