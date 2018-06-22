class StatementsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :update]
  before_action :statement_getter, except: [:index, :new, :create, :import]

  def index
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

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
