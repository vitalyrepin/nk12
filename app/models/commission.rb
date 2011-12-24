class Commission < ActiveRecord::Base
  has_ancestry
  has_many :comments
  
  def pct(target)
    if self.send(target).to_i > 0
      if target == "poll"
        100 * self.valid_ballots.to_i/self.send(target).to_i
      else  
        100 * self.send(target).to_i/self.valid_ballots.to_i
      end
    else
      0
    end
  end
end
