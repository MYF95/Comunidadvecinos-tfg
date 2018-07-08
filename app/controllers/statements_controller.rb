class StatementsController < ApplicationController
  helper_method :sort_column, :sort_direction, :sort_movement_column
  before_action :logged_in_user
  before_action :statement_getter, except: [:index, :new, :create, :bucket]

  def index
    @statements = Statement.order(sort_column + " " + sort_direction).paginate(per_page: 7, page: params[:page])
  end

  def new
    @statement = Statement.new
  end

  def create
    if current_user.admin?
      @statement = Statement.new(statement_params)
      if @statement.date.nil?
        @statement.date = Date.today.to_s
      end
      import_csv
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
    @movements = @statement.movements.order(sort_movement_column + " " + sort_direction).paginate(per_page: 7, page: params[:page])
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

  def bucket
    @statements = Statement.order(sort_column + " " + sort_direction).paginate(per_page: 7, page: params[:page])
  end

  private

    def sort_column
      Statement.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    def sort_movement_column
      Movement.column_names.include?(params[:sort]) ? params[:sort] : "concept"
    end

    def statement_getter
      @statement = Statement.find(params[:id])
    end

    def statement_params
      params.require(:statement).permit(:name, :date, :bank_statement)
    end

    def import_csv
      CSV.parse(@statement.bank_statement.download.force_encoding('UTF-8'), headers: true) do |row|
        row = row.to_hash
        movement_digest = Digest::MD5.hexdigest(row.to_s)
        movement = Movement.find_by(movement_digest: movement_digest)
        if movement.nil?
          movement = Movement.new(date: row['Fecha Movimiento'], date_value: row['Fecha Valor'], concept: row['Concepto'],
                                  amount: row['Importe'].sub(',', '.').to_f, currency_movement: row['Divisa'],
                                  post_balance: row['Saldo Posterior'].sub(',', '.').to_f, currency_balance: row['Divisa'],
                                  office: row['Oficina'], concept1: row['Concepto1'], concept2: row['Concepto2'],
                                  concept3: row['Concepto3'], concept4: row['Concepto4'], concept5: row['Concepto5'],
                                  concept6: row['Concepto6'], movement_digest: movement_digest)
          movement.lock!
          movement.save!
          StatementMovement.create!(statement: @statement, movement: Movement.last)
        else
          StatementMovement.create!(statement: @statement, movement: movement)
        end
      end
    end
end
