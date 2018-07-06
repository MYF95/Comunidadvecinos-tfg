class MovementsController < ApplicationController
  helper_method :sort_column, :sort_direction, :sort_apartment_column
  before_action :logged_in_user
  before_action :movement_getter, except: [:index, :new, :create, :destroy_statement]
  before_action :permissions, except: [:index, :show]
  before_action :check_amount, only: [:associate_apartment]

  def index
    @movements = Movement.where("amount > ?", 0).order(sort_column + " " + sort_direction).paginate(per_page: 7, page: params[:page])
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
    destroy_movement
  end

  def destroy_statement
    @statement = Statement.find(params[:id])
    @movement = Movement.find(params[:movement_id])
    if @movement.statements.count > 1
      if StatementMovement.find_by(statement: @statement, movement: @movement).destroy
        flash[:info] = "Movimiento borrado del extracto #{@statement.name}"
      else
        flash[:danger] = 'Ha ocurrido un error intentando eliminar el movimiento del extracto'
      end
      redirect_to @statement
    else
      destroy_movement
    end
  end

  def divide
  end

  def divide_movement
    amount = params[:movement][:amount].to_f
    if @movement.amount < amount || amount <= 0
      flash[:danger] = 'La cantidad que quiere dividir es mayor que la del movimiento o tiene un valor negativo. Vuelva a intentarlo.'
      redirect_to divide_path(@movement)
      return
    end
    if @movement.apartment.nil?
      create_movement_duplicate(@movement.amount - amount)
      create_movement_duplicate(amount)
      redirect_to movement_children_path(@movement)
    else
      flash[:danger] = 'Por favor, desasigna el movimiento de la vivienda antes de dividir el movimiento.'
      redirect_to edit_movement_path(@movement)
    end
  end

  def apartments
    @apartments = Apartment.order(sort_apartment_column + " " + sort_direction).paginate(per_page: 7, page: params[:page])
  end

  def associate_apartment
    @apartment = Apartment.find(params[:apartment_id])
    @apartmentmovement = ApartmentMovement.find_by(movement: @movement)
    if @apartmentmovement.nil?
      @apartmentmovement = ApartmentMovement.new(apartment: @apartment, movement: @movement)
      if @apartmentmovement.save
        @apartment.update_attribute(:balance, @apartment.balance + @movement.amount)
        flash[:info] = "Se ha asociado el movimiento a la vivienda #{full_name_apartment(@apartment)}"
      else
        flash[:danger] = 'Ha ocurrido un error al intentar crear la asociación del movimiento'
      end
      redirect_to apartment_path(@apartment)
    else
      old_apartment = @apartmentmovement.apartment
      if @apartmentmovement.update_attribute(:apartment, @apartment)
        flash[:info] = "Se ha cambiado la asociación a la vivienda #{full_name_apartment(@apartment)}"
        while old_apartment.balance - @movement.amount < 0
          newest_pending_payment = old_apartment.pending_payments.where(paid: true).order('date desc').first
          break if newest_pending_payment.nil?
          newest_pending_payment.update_attributes(paid: false, paid_by: nil)
          flash[:info] = "El cambio de asociación de movimiento ha cancelado el pago(s) más reciente(s) de la vivienda. Se han generado pagos pendientes."
        end
        old_apartment.update_attribute(:balance, old_apartment.balance - @movement.amount)
        @apartment.update_attribute(:balance, @apartment.balance + @movement.amount)
      else
        flash[:danger] = 'Ha ocurrido un error al intentar cambiar la asociación del movimiento'
      end
      redirect_to old_apartment
    end
  end

  def remove_apartment
    @apartment = @movement.apartment
    @apartmentmovement = ApartmentMovement.find_by(apartment: @movement.apartment, movement: @movement)
    if @apartmentmovement.destroy
      flash[:info] = "Movimiento desasociado de la vivienda #{full_name_apartment(@apartment)}"
      while @apartment.balance - @movement.amount < 0
        newest_pending_payment = @apartment.pending_payments.where(paid: true).order('date desc').first
        break if newest_pending_payment.nil?
        newest_pending_payment.update_attributes(paid: false, paid_by: nil)
        flash[:info] = "La desasociación de movimiento ha cancelado el pago(s) más reciente(s) de la vivienda. Se han generado pagos pendientes."
      end
      @apartment.update_attribute(:balance, @apartment.balance - @movement.amount)
    else
      flash[:danger] = 'Ha ocurrido un error al desasociar el movimiento de la vivienda'
    end
    redirect_to movements_path
  end

  def children
  end

  private

    def sort_column
      Movement.column_names.include?(params[:sort]) ? params[:sort] : "date"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    def sort_apartment_column
      Apartment.column_names.include?(params[:sort]) ? params[:sort] : "floor"
    end

    def movement_getter
      @movement = Movement.find(params[:id])
    end

    def movement_params
      params.require(:movement).permit(:description, :amount)
    end

    def permissions
      unless current_user.admin?
        flash[:danger] = 'Tu cuenta no tiene permisos para realizar esa acción. Por favor, contacta con el administrador para más información.'
        redirect_to root_path
      end
    end

    def check_amount
      unless @movement.amount >= 0
        flash[:danger] = 'El movimiento seleccionado tiene un valor negativo, no se puede añadir a una vivienda.'
        redirect_to statement_path(@movement.statements.first)
      end
    end

    def destroy_movement
      if @movement.destroy
        flash[:info] = 'Movimiento borrado'
        redirect_to movements_path
      else
        redirect_to root_url
      end
    end

    def create_movement_duplicate(amount)
      new_movement = @movement.dup
      new_movement.amount = amount
      new_movement.concept += " | Nº #{@movement.children.count + 1}"
      if new_movement.save
        movement_child = MovementChild.new(parent: @movement, child: new_movement)
        if movement_child.save
          flash[:info] = 'Se ha creado el movimiento duplicado'
        else
          flash[:danger] = 'Error en la creación del movimiento duplicado'
          redirect_to statements_path
        end
      else
        flash[:danger] = 'Error en la creación del movimiento duplicado'
        redirect_to statements_path
      end
    end
end
