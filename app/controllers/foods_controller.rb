class FoodsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @foods = Food.all
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
    params.require(:food).permit(:title, :description, :start_time, :end_time, :quantity, :kind_of_food, photos: [])
  end
end
