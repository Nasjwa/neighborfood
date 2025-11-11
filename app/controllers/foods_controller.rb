class FoodsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @foods = Food.all
    if params[:query].present?
      sql_subquery = <<~SQL
        foods.title @@ :query
        OR foods.description @@ :query
        OR users.post_code @@ :query
        OR users.first_name @@ :query
      SQL
      @foods = @foods.joins(:user).where(sql_subquery, query: params[:query])
    end

  end

  def show
    @food = Food.find(params[:id])
  end

  def new
    @food = Food.new

  end

  def create
    @food = current_user.foods.build(food_params.except(:photos))

    if @food.save
      # attach files after the model is saved
      if params[:food][:photos].present?
        @food.photos.attach(params[:food][:photos])
      end
      redirect_to @food, notice: "Food created"
    else
      # If save failed, we didn't attach files — show form again
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def food_params
    params.require(:food).permit(:title, :description, :start_time, :end_time, :quantity, :kind_of_food, :cooking_date, :expire_date, photos: [])
  end
end
