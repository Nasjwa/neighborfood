class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show
    @user_foods  = @user.foods
    @claims = @user.claims.includes(:food)
    @active_tab  = params[:tab].presence_in(%w[details listings claims]) || "details"
    @reviews = @user.reviews.includes(:food)
  end

  def edit
    # just renders app/views/users/edit.html.erb
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user, tab: "details"), notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def user_foods
    @user_foods = current_user.foods
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :post_code, :address, :email)
  end
end
