class FoodsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @foods = Food.all
    @tags = Tag.all
    @nearby    = Food.limit(6)
    @cooked = Food.where(kind_of_food: 0).includes(:tags).order(created_at: :desc)
    @groceries = Food.where(kind_of_food: 1).includes(:tags).order(created_at: :desc)

    if params[:query].present?
      sql_subquery = <<~SQL
        foods.title @@ :query
        OR foods.description @@ :query
        OR users.post_code @@ :query
        OR users.first_name @@ :query
      SQL
      @foods = @foods.joins(:user).where(sql_subquery, query: params[:query])
    end

    @foods = Food.joins(:user).where.not(users: { latitude: nil, longitude: nil })

    @markers = @foods.map do |food|
      next unless food.user&.latitude && food.user&.longitude

      {
        lat: food.user.latitude,
        lng: food.user.longitude,                    # use lng if your JS expects it
        info_window_html: render_to_string(partial: "info_window", locals: { food: food }),
        marker_html: render_to_string(partial: "marker", locals: { food: food })
      }
    end.compact
  end

  def show
    @food = Food.find(params[:id])
  end

  def new
    @food = Food.new

  end

  def create
    # include tag_ids in the mass-assignment, but still skip photos (we attach them after save)
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
    params.require(:food).permit(:title, :description, :start_time, :end_time, :quantity, :kind_of_food, :cooking_date, :expire_date, tag_ids: [], photos: [])
  end

end
