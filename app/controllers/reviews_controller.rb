class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_food

  def new
    @food = Food.find(params[:food_id])
    @review = Review.new
  end
  def create

  @food = Food.find(params[:food_id])

  unless current_user.claims.exists?(food_id: @food.id)
    redirect_to claims_path, alert: "You can't review food that you didn't claim."
    return
  end

    @review = @food.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to @food, notice: "Thank you for sharing your opinion!"
    else
      flash.now[:alert] = "Could not save review."
      render "foods/show", status: :unprocessable_entity
    end
  end

  def show
    @review = @food.reviews.find(params[:id])
  end
  
  def destroy
    @review = @food.reviews.find(params[:id])

    if @review.user == current_user
      @review.destroy
      redirect_to @food, notice: "Review deleted!"
    else
      redirect_to @food, alert: "You are not able to delete this review!"
    end
  end
    
  private

  def set_food
    @food = Food.find(params[:food_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
