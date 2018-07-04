class MovementsController < ApplicationController
  before_action :logged_in_user
  before_action :movement_getter, except: [:index, :new, :create]
  before_action :divide_getter, only: [:divide, :divide_movement]
  before_action :permissions, except: [:index, :show]

  def index
    @movements = Movement.all
  end

  def new
    @movement = Movement.new
  end

  def create
    @movement = Movement.new(movement_params)
    if @movement.save
      flash[:info] = "¡Nuevo movimiento #{@movement.concept} creado!"
      redirect_to @movement
    else
      flash[:danger] = 'Ha ocurrido un error en el sistema, por favor, vuelva a intentarlo.'
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @movement.update_attributes(movement_params)
      flash[:info] = 'Movimiento actualizado'
      redirect_to @movement
    else
      render 'edit'
    end
  end

  def destroy
    if @movement.destroy
      flash[:info] = 'Movimiento borrado'
      redirect_to movements_path
    else
      redirect_to root_url
    end
  end

  def create_for_statement
    @statement = Statement.find(params[:id])
    @movement = Movement.new(movement_params)
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
  end

  def divide
  end

  def divide_movement
    @new_movement = Movement.new(movement_params)
    amount = @new_movement.amount
    if @new_movement.amount >= @movement.amount
      flash[:danger] = 'La cantidad que quieres separar es mayor o igual al original, prueba con otra cantidad.'
      redirect_to @statement
    else
      @movement.amount -= amount
      @movement.save
      if @new_movement.save
        @statementmovement = StatementMovement.new(statement_id: @statement.id, movement_id: @new_movement.id)
        if @statementmovement.save
          flash[:info] = "Se ha dividido el movimiento #{@movement.concept}"
          redirect_to @statement
        else
          flash[:danger] = 'Ha ocurrido un error a la hora de dividir el movimiento para el extracto bancarios.'
          redirect_to root_url
        end
      else
        flash[:danger] = 'Ha ocurrido un error en la creación del movimiento bancario.'
      end
    end
  end

  def apartments
    @apartments = Apartment.all
  end

  def associate_apartment
    if @movement.amount < 0
      flash[:danger] = 'El movimiento seleccionado tiene un valor negativo, no se puede añadir a una vivienda.'
    else
      @apartment = Apartment.find(params[:apartment_id])
      @apartmentmovement = ApartmentMovement.find_by(movement: @movement)
      if @apartmentmovement.nil?
        @apartmentmovement = ApartmentMovement.new(apartment: @apartment, movement: @movement)
        if @apartmentmovement.save
          @apartment.update_attribute(:balance, @apartment.balance + @movement.amount)
          flash[:info] = "Se ha asociado el movimiento a la vivienda #{full_name_apartment(@apartment)}"
          redirect_to statement_path(@movement.statements.first)
        else
          flash[:danger] = 'Ha ocurrido un error al intentar crear la asociación del movimiento'
          redirect_to statement_path(@movement.statements.first)
        end
      else
        old_apartment = @apartmentmovement.apartment
        if @apartmentmovement.update_attribute(:apartment, @apartment)
          flash[:info] = "Se ha cambiado la asociación a la vivienda #{full_name_apartment(@apartment)}"
          while old_apartment.balance - @movement.amount < 0
            newest_pending_payment = old_apartment.pending_payments.where(paid: true).order('date desc').first
            break if newest_pending_payment.nil?
            newest_pending_payment.update_attribute(:paid, false)
            flash[:info] = "El cambio de asociación de movimiento ha cancelado el pago(s) más reciente(s) de la vivienda. Se han generado pagos pendientes."
          end
          old_apartment.update_attribute(:balance, old_apartment.balance - @movement.amount)
          @apartment.update_attribute(:balance, @apartment.balance + @movement.amount)
          redirect_to old_apartment
        else
          flash[:danger] = 'Ha ocurrido un error al intentar cambiar la asociación del movimiento'
          redirect_to old_apartment
        end
      end
    end
  end

  private

  def movement_getter
    @movement = Movement.find(params[:id])
  end

  def movement_params
    params.require(:movement).permit(:description)
  end

  def divide_getter
    @movement = Movement.find(params[:id_movement])
    @statement = Statement.find(params[:id])
  end

  def permissions
    unless current_user.admin?
      flash[:danger] = 'Tu cuenta no tiene permisos para realizar esa acción. Por favor, contacta con el administrador para más información.'
      redirect_to root_path
    end
  end
end
