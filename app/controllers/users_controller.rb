class UsersController < ApplicationController
  before_action :logged_in_user
  before_action :permissions, except: [:show, :index]
  before_action :user_getter, except: [:user_list, :index]

  def show
  end

  def user_list
    @apartment = Apartment.find(params[:id])
    @users = User.all
  end

  def index
    @users = User.all
  end

  def destroy
    if @user.destroy
      flash[:info] = 'Usuario eliminado.'
    else
      flash[:danger] = 'Ha ocurrido un error intentando eliminar al usuario'
    end
    redirect_to users_path
  end

  private

    def user_getter
      @user = User.find(params[:id])
    end

    def permissions
      unless current_user.admin?
        flash[:danger] = 'Tu cuenta no tiene permisos para realizar esa acción. Por favor, contacta con el administrador para más información.'
        redirect_to root_path
      end
    end
end
