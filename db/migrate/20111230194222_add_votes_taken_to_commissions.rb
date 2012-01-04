class AddVotesTakenToCommissions < ActiveRecord::Migration
  def change
    add_column :commissions, :votes_taken, :boolean
  end
end
