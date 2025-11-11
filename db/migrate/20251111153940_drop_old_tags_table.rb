class DropOldTagsTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :tags, if_exists: true
  end
end