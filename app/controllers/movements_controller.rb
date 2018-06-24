class MovementsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :update]
  before_action :movement_getter, except: [:index, :new, :create]

  def index
    @movements = Movement.all
  end

  def new
    @movement = Movement.new
    @statement = Statement.find_by(id: params[:id])
  end

  def create
    if current_user.admin?
      @movement = Movement.new(movement_params)
      if @movement.save
        flash[:info] = "¡Nuevo movimiento #{@movement.concept} creado!"
        redirect_to @movement
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
      if @movement.update_attributes(movement_params)
        flash[:info] = 'Movimiento actualizado'
        redirect_to @movement
      else
        render 'edit'
      end
    else
      permissions
    end
  end

  def destroy
    if current_user.admin
      if @movement.destroy
        flash[:info] = 'Movimiento borrado'
        redirect_to movements_path
      else
        redirect_to root_url
      end
    else
      permissions
    end
  end

  def create_for_statement
    if current_user.admin
      @movement = Movement.new(movement_params)
      @statement = Statement.find(params[:id])
      if @movement.save
        @statementmovement = StatementMovement.new(statement_id: @statement.id, movement_id: @movement.id)
        if @statementmovement.save
          flash[:info] = "Movimiendo creado para el extracto '#{@statement.name}'"
          redirect_to @statement
        else
          flash[:danger] = 'Ha ocurrido un error a la hora de crear el movimiento para el extracto.'
          redirect_to root_url
        end
      else
        flash[:danger] = 'Ha ocurrido un error en la creación del movimiento bancario.'
      end
    else
      permissions
    end
  end

  private

  def movement_getter
    @movement = Movement.find(params[:id])
  end

  def movement_params
    params.require(:movement).permit(:concept, :date, :amount, :description)
  end

  def permissions
    flash[:danger] = 'Tu cuenta no tiene permisos para realizar esa acción. Por favor, contacta con el administrador para más información.'
    redirect_to root_path
  end
end
