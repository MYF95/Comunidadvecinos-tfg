class UsersController < ApplicationController
  before_action :logged_in_user

  def show
    @user = User.find(params[:id])
  end

  def index
    @apartment = Apartment.find(params[:id])
    @users = User.all
  end
end
