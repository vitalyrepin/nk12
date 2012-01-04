class AddUikHolderToCommissions < ActiveRecord::Migration
  def change
    add_column :commissions, :uik_holder, :boolean, :default => 0
  end
end
