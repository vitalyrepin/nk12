class ProtocolsController < ApplicationController
  def new
    @uik = Commission.find_by_id!(params[:commission_id])
    @protocol = @uik.protocols.new
    respond_to do |format| 
      format.html # search.html.erb
    end

  end
  
  def create
  end  
end
