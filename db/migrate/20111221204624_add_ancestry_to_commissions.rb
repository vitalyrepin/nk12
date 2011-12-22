class AddAncestryToCommissions < ActiveRecord::Migration
  def change
    add_column :commissions, :ancestry, :string
    add_index :commissions, :ancestry
  end
end
