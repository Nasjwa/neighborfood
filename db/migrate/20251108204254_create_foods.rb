class CreateFoods < ActiveRecord::Migration[7.1]
  def change
    create_table :foods do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.datetime :start_time
      t.datetime :end_time
      t.integer :kind_of_food
      t.date :cooking_date
      t.date :expire_date
      t.integer :quantity

      t.timestamps
    end
  end
end
