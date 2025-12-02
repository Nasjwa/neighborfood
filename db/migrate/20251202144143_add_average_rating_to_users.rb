class AddAverageRatingToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :average_rating, :float
  end
end
