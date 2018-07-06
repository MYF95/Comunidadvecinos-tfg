class UsersController < ApplicationController
  helper_method :sort_column, :sort_direction, :sort_apartment_column
  before_action :logged_in_user
  before_action :permissions, except: [:show, :index]
  before_action :user_getter, except: [:user_list, :index]

  def show
  end

  def user_list
    @apartment = Apartment.find(params[:id])
    @users = User.order(sort_column + " " + sort_direction).paginate(per_page: 7, page: params[:page])
  end

  def index
    @users = User.order(sort_column + " " + sort_direction).paginate(per_page: 7, page: params[:page])
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

    def sort_column
      User.column_names.include?(params[:sort]) ? params[:sort] : "first_name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    def sort_apartment_column
      Apartment.column_names.include?(params[:sort]) ? params[:sort] : "floor"
    end

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
