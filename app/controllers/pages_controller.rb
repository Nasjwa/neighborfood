class PagesController < ApplicationController
  def home
    @tags = %w[Vegan Vegetarian Gluten-free Halal Kosher Dairy-free Low-salt]

    # These can be empty; the view will show placeholders when empty
    @nearby    = Food.limit(6)
    @cooked    = Food.none
    @groceries = Food.none
  end
end
