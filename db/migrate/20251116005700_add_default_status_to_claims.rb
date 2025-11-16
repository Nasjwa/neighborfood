class AddDefaultStatusToClaims < ActiveRecord::Migration[7.1]
  def change
    change_column_default :claims, :status, from: nil, to: "pending"
  end
end
