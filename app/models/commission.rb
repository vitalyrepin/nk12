class Commission < ActiveRecord::Base
  has_ancestry
   
  belongs_to :election
  has_many :comments, :dependent => :destroy 
  has_many :protocols, :dependent => :destroy 
  has_many :votings, :dependent => :destroy 
  has_many :voting_dictionaries, :through => :votings
  def self.with_votes    
    self.includes(:votings,:voting_dictionaries)
  # .where("voting_dictionaries.main_role",true)
  end

  def get_names
    # self.election.voting_dictionaries.map(&:en_name)
  end

  def pct(target)
    10
    # self.votings.joins(:voting_dictionary).where(:voting_dictionary => {:en_name => target})
    # if self.send(target).to_i > 0
    #   if target == "poll"
    #     100 * self.valid_ballots.to_i/self.send(target).to_i
    #   else  
    #     100 * self.send(target).to_i/self.valid_ballots.to_i
    #   end
    # else
    #   0
    # end
  end
  
end
