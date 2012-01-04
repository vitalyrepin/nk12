class AddVotingTableUrlToCommissions < ActiveRecord::Migration
  def change
    add_column :commissions, :voting_table_url, :string
  end
end
