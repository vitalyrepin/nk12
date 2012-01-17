class AddIndexes < ActiveRecord::Migration
  def change
    add_index :votings, :commission_id
    add_index :votings, :voting_dictionary_id
  end
end
