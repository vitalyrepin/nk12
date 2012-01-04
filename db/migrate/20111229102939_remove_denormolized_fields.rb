class RemoveDenormolizedFields < ActiveRecord::Migration
	def change
		remove_column :commissions, :votings
		remove_column :elections, :voting_names
	end
end
