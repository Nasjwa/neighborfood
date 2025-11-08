class CreateClaims < ActiveRecord::Migration[7.1]
  def change
    create_table :claims do |t|
      t.references :user, null: false, foreign_key: true
      t.references :food, null: false, foreign_key: true
      t.datetime :collect_time
      t.string :status

      t.timestamps
    end
  end
end
