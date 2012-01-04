class HomeController < ApplicationController
  def index
    @elections = Election.find(:all)
    # @commissions = Commission.roots
  end
  def show
    
    @commission = Commission.find(params[:id])
    @election = @commission.election
    # @commission = Commission.all(:include => :votings, :conditions => {:is_uik => false})
  end
end
