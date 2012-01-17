class CreateElections < ActiveRecord::Migration
  def change
    create_table :elections do |t|
      t.string :name
      t.string :url
      t.text :voting_names

      t.timestamps
    end
  end
end
