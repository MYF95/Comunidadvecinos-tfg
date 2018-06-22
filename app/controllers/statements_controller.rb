class StatementsController < ApplicationController
  #TODO make this options available only to Admin
  before_action :logged_in_user, only: [:create, :destroy, :update]
  before_action :statement_getter, except: [:index, :new, :create, :import]

  def index
    @statements = Statement.all
  end

  def new
    @statement = Statement.new
  end

  def create
    if current_user.admin?
      @statement = Statement.new(statement_params)
      if @statement.save
        flash[:info] = "¡Nuevo extracto #{@statement.name} creado!"
        redirect_to @statement
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
      if @statement.update_attributes(statement_params)
        flash[:info] = 'Extracto bancario actualizado'
        redirect_to @statement
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
      if @statement.destroy
        flash[:info] = 'Extracto bancario borrado'
        redirect_to statements_path
      else
        redirect_to root_url
      end
    else
      flash[:danger] = 'Tu cuenta no tiene permisos para realizar esa acción. Por favor, contacta con el administrador para más información.'
      redirect_to root_path
    end
  end

  #TODO import statement

  def import
  end

  private

    def statement_getter
      @statement = Statement.find(params[:id])
    end

    def statement_params
      params.require(:statement).permit(:name, :date)
    end
end
