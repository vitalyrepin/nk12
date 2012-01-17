class Voting < ActiveRecord::Base
  belongs_to :commission
  belongs_to :voting_dictionary

  validates_uniqueness_of :commission_id, :scope => :voting_dictionary_id

end
