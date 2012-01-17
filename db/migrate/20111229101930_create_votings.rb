class CreateVotings < ActiveRecord::Migration
  def change
    create_table :votings do |t|
      t.integer :commission_id
      t.integer :votes
      t.integer :voting_dictionary_id

      t.timestamps
    end
  end
end
