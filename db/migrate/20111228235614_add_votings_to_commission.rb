class AddVotingsToCommission < ActiveRecord::Migration
  def change
    add_column :commissions, :votings, :text
    add_column :commissions, :election_id, :integer
    remove_column :commissions, :poll
    remove_column :commissions, :received_by_commission
    remove_column :commissions, :voted_early

    remove_column :commissions, :voted_in
    remove_column :commissions, :voted_out
    remove_column :commissions, :canceled_ballots
    remove_column :commissions, :mobile_ballots
    remove_column :commissions, :stationary_ballots
    remove_column :commissions, :invalid_ballots
    remove_column :commissions, :valid_ballots

    remove_column :commissions, :absentee_ballots_all
    remove_column :commissions, :absentee_ballots_given
    remove_column :commissions, :absentee_ballots_voted
    remove_column :commissions, :unused_absentee_ballots
    remove_column :commissions, :absentee_territorial
    remove_column :commissions, :lost_absentee_ballots
    remove_column :commissions, :ballots_not_taken

    remove_column :commissions, :sr
    remove_column :commissions, :ldpr
    remove_column :commissions, :pr
    remove_column :commissions, :kprf
    remove_column :commissions, :yabloko
    remove_column :commissions, :er
    remove_column :commissions, :pd
  end
end
