class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.references :food, null: false, foreign_key: true
      t.boolean :vegan
      t.boolean :vegetarian
      t.boolean :gluten_free
      t.boolean :nuts_free

      t.timestamps
    end
  end
end
