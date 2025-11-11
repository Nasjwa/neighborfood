class PagesController < ApplicationController
  def home
   @tags = Tag.all

    # These can be empty; the view will show placeholders when empty
    @nearby    = Food.limit(6)
    @cooked = Food.where(kind_of_food: 0).includes(:tags).order(created_at: :desc)
    @groceries = Food.where(kind_of_food: 1).includes(:tags).order(created_at: :desc)
  end
end
