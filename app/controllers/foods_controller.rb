class FoodsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :set_food, only: [:show, :edit, :update, :destroy]

def index
  @tags = Tag.all
  selected_tags = Array(params[:tags])

  base_scope = Food
    .joins(:user)
    .left_joins(:tags)
    .left_joins(:claims)
    .where.not(users: { latitude: nil, longitude: nil })
    .where("claims.id IS NULL OR claims.status != ?", "claimed")
    .distinct

  if params[:query].present?
    sql_subquery = <<~SQL
      foods.title @@ :query
      OR foods.description @@ :query
      OR foods.title @@ :query
      OR users.post_code @@ :query
      OR users.first_name @@ :query
      OR tags.name @@ :query
    SQL

    base_scope = base_scope.where(sql_subquery, query: params[:query])
  end

  if selected_tags.any?
    strict_matches = base_scope
      .where(tags: { name: selected_tags })
      .group("foods.id")
      .having("COUNT(DISTINCT tags.id) = ?", selected_tags.size)

    if strict_matches.exists?
      base_scope = strict_matches
    else
      base_scope = base_scope.where(tags: { name: selected_tags })
    end
  end

  @foods = base_scope

  @nearby    = base_scope.all
  @cooked    = base_scope.where(kind_of_food: 0).order(created_at: :desc).all
  @groceries = base_scope.where(kind_of_food: 1).order(created_at: :desc).all

  @markers = base_scope.map do |food|
    next unless food.user&.latitude && food.user&.longitude

    {
      lat: food.user.latitude,
      lng: food.user.longitude,
      info_window_html: render_to_string(partial: "info_window", locals: { food: food }),
      marker_html: render_to_string(partial: "marker", locals: { food: food })
    }
  end.compact
end


  def show
    @food = Food.find(params[:id])

    # Only build a marker for the shown food so the map centers on it
    if @food.user&.latitude && @food.user&.longitude
      @markers = [{
        lat: @food.user.latitude.to_f,
        lng: @food.user.longitude.to_f,
        info_window_html: render_to_string(partial: "info_window", locals: { food: @food }),
        marker_html: render_to_string(partial: "marker", locals: { food: @food })
      }]
    else
      @markers = []
    end
    Rails.logger.debug "MARKERS: #{@markers.inspect}"
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
    if @food.update(food_params)
      redirect_to @food, notice: "Food updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @food.destroy
    redirect_to foods_path, notice: "Food deleted"
  end

  private

  def set_food
    @food = Food.find(params[:id])
  end

  def food_params
    params.require(:food).permit(:title, :description, :start_time, :end_time, :quantity, :kind_of_food, :cooking_date, :expire_date, tag_ids: [], photos: [])
  end

end
