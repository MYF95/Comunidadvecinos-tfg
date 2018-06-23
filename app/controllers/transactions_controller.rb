class TransactionsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :update]
  before_action :transaction_getter, except: [:index, :new, :create]

  def index
    @transactions = Transaction.all
  end

  def new
    @transaction = Transaction.new
  end

  def create
    if current_user.admin?
      @transaction = Transaction.new(transaction_params)
      if @transaction.save
        flash[:info] = "¡Nuevo movimiento #{@transaction.concept} creado!"
        redirect_to @transaction
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
      if @transaction.update_attributes(transaction_params)
        flash[:info] = 'Movimiento actualizado'
        redirect_to @transaction
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
      if @transaction.destroy
        flash[:info] = 'Movimiento borrado'
        redirect_to transactions_path
      else
        redirect_to root_url
      end
    else
      flash[:danger] = 'Tu cuenta no tiene permisos para realizar esa acción. Por favor, contacta con el administrador para más información.'
      redirect_to root_path
    end
  end

  private

  def transaction_getter
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:concept, :date, :amount, :description)
  end
end
