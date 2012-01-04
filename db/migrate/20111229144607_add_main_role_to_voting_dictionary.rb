class AddMainRoleToVotingDictionary < ActiveRecord::Migration
  def change
    add_column :voting_dictionaries, :main_role, :boolean, :default => 0
  end
end
