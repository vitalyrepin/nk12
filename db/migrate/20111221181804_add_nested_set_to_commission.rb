class AddNestedSetToCommission < ActiveRecord::Migration
  def change
    add_column :commissions, :parent_id, :integer
    add_column :commissions, :lft, :integer
    add_column :commissions, :rgt, :integer
  end
end
