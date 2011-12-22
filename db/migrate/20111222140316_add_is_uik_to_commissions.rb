class AddIsUikToCommissions < ActiveRecord::Migration
  def change
    add_column :commissions, :is_uik, :boolean, :default => 0
  end
end
