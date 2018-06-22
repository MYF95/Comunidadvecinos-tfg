class PendingPaymentsController < ApplicationController
  #TODO make this options available only to Admin
  before_action :logged_in_user, only: [:create, :destroy, :update]
  before_action :pending_payment_getter, except: [:index, :new, :create]

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

  #TODO Flash errors in spanish

  def update
  end

  def destroy
  end

  private

  def pending_payment_getter
    @apartment = PendingPayment.find(params[:id])
  end

  def pending_payment_params
    params.require(:pending_payment).permit(:concept, :date, :amount, :description, :paid)
  end
end
