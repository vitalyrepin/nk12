class PrepToAncestry < ActiveRecord::Migration
  def change
    # remove_column :commissions, :parent_id
    remove_column :commissions, :lft
    remove_column :commissions, :rgt
  end
end
