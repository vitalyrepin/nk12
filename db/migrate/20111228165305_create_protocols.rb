class CreateProtocols < ActiveRecord::Migration
  def change
    create_table :protocols do |t|

      t.integer :poll
      t.integer :received_by_commission
      t.integer :voted_early
      
      t.integer :voted_in
      t.integer :voted_out
      t.integer :canceled_ballots
      t.integer :mobile_ballots
      t.integer :stationary_ballots
      t.integer :invalid_ballots
      t.integer :valid_ballots

      t.integer :absentee_ballots_all
      t.integer :absentee_ballots_given
      t.integer :absentee_ballots_voted
      t.integer :unused_absentee_ballots
      t.integer :absentee_territorial
      t.integer :lost_absentee_ballots
      t.integer :ballots_not_taken
      
      t.integer :sr
      t.integer :ldpr
      t.integer :pr
      t.integer :kprf
      t.integer :yabloko
      t.integer :er
      t.integer :pd
      
      t.integer :commission_id      
      
      t.timestamps
    end
  end
end
