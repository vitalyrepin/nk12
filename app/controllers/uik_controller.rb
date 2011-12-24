class UikController < ApplicationController
  def index
    @uiks = Commission.find :all, :joins => :comments
    # Commission.includes([:comments]).where(:is_uik=>true)
  end

  def show
    @uik = Commission.find(params[:id])
  end

end
