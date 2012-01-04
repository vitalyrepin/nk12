class AddVotinglabelsToElection < ActiveRecord::Migration
  def change
    add_column :elections, :voting_labels, :text
  end
end
