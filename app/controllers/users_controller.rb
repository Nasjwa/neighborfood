class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def user_foods
    @user_foods = current_user.foods
  end
end
