class StatementsController < ApplicationController
  helper_method :sort_column, :sort_direction, :sort_movement_column
  before_action :logged_in_user
  before_action :statement_getter, except: [:index, :new, :create, :bucket]
  before_action :permissions, except: [:index, :show]

  def index
    @statements = Statement.order(sort_column + " " + sort_direction).paginate(per_page: 7, page: params[:page])
  end

  def new
    @statement = Statement.new
  end

  def create
    @statement = Statement.new(statement_params)
    if @statement.date.nil?
      @statement.date = Date.today.to_s
    end
    if @statement.bank_statement.attached?
      if @statement.save
        return unless check_csv.nil?
        flash[:info] = "¡Nuevo extracto #{@statement.name} creado!"
        return if import_csv.nil?
        redirect_to @statement
      else
        flash[:danger] = 'Ha ocurrido un error en el sistema, por favor, vuelva a intentarlo.'
        render 'new'
      end
    else
      flash[:danger] = 'No hay ningún archivo para importar. Vuelva a intentarlo.'
      render 'new'
    end
  end

  def show
    @movements = @statement.movements.order(sort_movement_column + " " + sort_direction).paginate(per_page: 7, page: params[:page])
  end

  def edit
  end

  def update
    if @statement.update_attributes(statement_params)
      flash[:info] = 'Extracto bancario actualizado'
      redirect_to @statement
    else
      render 'edit'
    end
  end

  def destroy
    if @statement.destroy
      flash[:info] = 'Extracto bancario borrado'
      redirect_to statements_path
    else
      redirect_to root_url
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

    def permissions
      unless current_user.admin?
        flash[:danger] = 'Tu cuenta no tiene permisos para realizar esa acción. Por favor, contacta con el administrador para más información.'
        redirect_to root_path
      end
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
        if check_csv_params(row).nil?
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

    def check_csv
      unless @statement.bank_statement.blob.content_type == 'text/csv'
        @statement.destroy
        flash[:danger] = 'El archivo a importar no es un fichero CSV. Vuelva a intentarlo.'
        redirect_to new_statement_path
        false
      end
    end

    def check_csv_params(row)
      if row['Fecha Movimiento'].nil? && row['Concepto'].nil? && row['Importe'].nil?
        @statement.destroy
        flash[:danger] = 'El CSV importado no tiene las columnas mínimas de "Fecha Movimiento", "Concepto" e "Importe" para ser procesado.'
        redirect_to new_statement_path
        false
      end
    end
end
