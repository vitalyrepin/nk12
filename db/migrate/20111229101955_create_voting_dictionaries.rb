class CreateVotingDictionaries < ActiveRecord::Migration
  def change
    create_table :voting_dictionaries do |t|
      t.string :name
      t.string :en_name
      t.integer :election_id
      t.integer :source_identifier
      t.timestamps
    end
  end
end
