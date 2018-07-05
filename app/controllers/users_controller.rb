class UsersController < ApplicationController
  before_action :logged_in_user
  before_action :permissions, except: [:show, :index]

  def show
    @user = User.find(params[:id])
  end

  def user_list
    @apartment = Apartment.find(params[:id])
    @users = User.all
  end

  def index
    @users = User.all
  end

  private

    def permissions
      unless current_user.admin?
        flash[:danger] = 'Tu cuenta no tiene permisos para realizar esa acción. Por favor, contacta con el administrador para más información.'
        redirect_to root_path
      end
    end
end
