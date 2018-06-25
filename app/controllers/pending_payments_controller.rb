class PendingPaymentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :update]
  before_action :pending_payment_getter, except: [:index, :new, :create]

  def index
    @pending_payments = PendingPayment.all
  end

  def new
    @pending_payment = PendingPayment.new
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

  private

  def pending_payment_getter
    @pending_payment = PendingPayment.find(params[:id])
  end

  def pending_payment_params
    params.require(:pending_payment).permit(:concept, :date, :amount, :description, :paid)
  end
end
