class PendingPaymentsController < ApplicationController
  helper_method :sort_column, :sort_direction, :sort_apartment_column
  before_action :logged_in_user
  before_action :pending_payment_getter, except: [:index, :new, :create, :new_all,:create_all]
  before_action :permissions, except: [:index, :show]

  def index
    @pending_payments = PendingPayment.order(sort_column + " " + sort_direction).paginate(per_page: 7, page: params[:page])
  end

  def new
    @pending_payment = PendingPayment.new
    @apartments = Apartment.all
  end

  def create
    @apartments = Apartment.all
    if @apartments.empty?
      flash[:danger] = 'La comunidad no tiene ninguna vivienda, por favor, crea las viviendas de la comunidad primero.'
      redirect_to apartments_path
    else
      date = params[:pending_payment][:date]
      month = l(date.to_date, format: "%B")
      @apartments.each do |apartment|
        @pending_payment = PendingPayment.new(concept: "Cuota de la vivienda #{full_name_apartment(apartment)} de #{month}", date: date, amount: apartment.fee, description: params[:pending_payment][:description])
        if @pending_payment.save
          if ApartmentPendingPayment.create!(apartment: apartment, pending_payment: @pending_payment)
            flash[:info] = 'Se han generado los pagos pendientes de las cuotas de las viviendas.'
          else
            flash[:danger] = 'Ha ocurrido un error a la hora de vincular los pagos pendientes a las viviendas.'
            break
          end
        else
          flash[:danger] = 'Ha ocurrido un error a la hora de crear los pagos pendientes de las viviendas'
          break
        end
      end
      redirect_to pending_payments_path
    end
  end

  def show
  end

  def edit
  end

  def update
    if @pending_payment.update_attributes(pending_payment_params)
      flash[:info] = 'Pago pendiente actualizada'
      redirect_to @pending_payment
    else
      render 'edit'
    end
  end

  def destroy
    if @pending_payment.destroy
      flash[:info] = 'Pago pendiente borrado'
      redirect_to pending_payments_path
    else
      redirect_to root_path
    end
  end

  def apartments
    @apartments = Apartment.order(sort_apartment_column + " " + sort_direction).paginate(per_page: 7, page: params[:page])
  end

  def associate_apartment
    @apartment = Apartment.find(params[:apartment_id])
    @apartmentpendingpayment = ApartmentPendingPayment.find_by(pending_payment: @pending_payment)
    if @apartmentpendingpayment.nil?
      @apartmentpendingpayment = ApartmentPendingPayment.new(apartment: @apartment, pending_payment: @pending_payment)
      if @apartmentpendingpayment.save
        flash[:info] = "Se ha asociado el pago pendiente a la vivienda #{full_name_apartment(@apartment)}"
      else
        flash[:danger] = 'Ha ocurrido un error al intentar crear la asociación del pago pendiente'
      end
    else
      if @apartmentpendingpayment.update_attribute(:apartment, @apartment)
        flash[:info] = "Se ha cambiado la asociación del pago pendiente a la vivienda #{full_name_apartment(@apartment)}"
      else
        flash[:danger] = 'Ha ocurrido un error al intentar cambiar la asociación del pago pendiente'
      end
    end
    redirect_to pending_payments_path
  end

  def new_all
  end

  def create_all
    if check_apartments_contribution
      months = params[:pending_payment][:months].to_i
      amount = params[:pending_payment][:amount].to_f
      Apartment.all.each do |apartment|
        apartment_fee = pending_payment_fee_calculator(months, amount, apartment)
        for i in 0..months-1
          date = params[:pending_payment][:date].to_date
          month = l(date + i.month, format: "%B")
          @pending_payment = PendingPayment.new(concept: params[:pending_payment][:concept] + " vivienda #{full_name_apartment(apartment)} de #{month}",
                                                date: (date + i.month).to_s, amount: apartment_fee, description: params[:pending_payment][:description],
                                                months: params[:pending_payment][:months])
          if @pending_payment.save
            ApartmentPendingPayment.create!(apartment: apartment, pending_payment: @pending_payment)
            flash[:info] = "Se han creado los pagos pendientes de #{params[:pending_payment][:concept]} correctamente"
          else
            flash[:danger] = "Se ha producido un error generando los pagos pendientes de la vivienda #{full_name_apartment(@apartment)}"
            break
          end
        end
      end
      redirect_to pending_payments_path
    else
      flash[:danger] = 'Hay viviendas con 0% de participación o el total de contribución no suma a 100%. Antes de crear derramas, actualiza las contribución de cada vivienda.'
      redirect_to apartments_path
    end
  end

  private

    def sort_column
      PendingPayment.column_names.include?(params[:sort]) ? params[:sort] : "date"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    def sort_apartment_column
      Apartment.column_names.include?(params[:sort]) ? params[:sort] : "floor"
    end

    def pending_payment_getter
      @pending_payment = PendingPayment.find(params[:id])
    end

    def pending_payment_params
      params.require(:pending_payment).permit(:concept, :date, :amount, :description, :months)
    end

    def create_pending_payment
      @pending_payment = PendingPayment.new(pending_payment_params)
      if @pending_payment.save
        flash[:info] = "¡Nuevo pago pendiente creado!"
        redirect_to @pending_payment
      else
        flash[:danger] = 'Ha ocurrido un error en el sistema, por favor, vuelva a intentarlo.'
        render 'new'
      end
    end

    def pending_payment_fee_calculator(months, amount, apartment)
      (amount / Apartment.all.count * apartment.apartment_contribution / months).round(2)
    end

    def check_apartments_contribution
      Apartment.where(apartment_contribution: 0.0).count < 1 && total_apartment_contribution(Apartment.first).equal?(1.0)
    end

    def permissions
      unless current_user.admin?
        flash[:danger] = 'Tu cuenta no tiene permisos para realizar esa acción. Por favor, contacta con el administrador para más información.'
        redirect_to root_path
      end
    end
end
