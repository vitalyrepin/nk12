class Election < ActiveRecord::Base  
  has_many :commissions, :dependent => :destroy
  has_many :voting_dictionaries, :dependent => :destroy 
end
