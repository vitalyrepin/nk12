class HomeController < ApplicationController
  def index
    @commissions = Commission.roots
  end
  def show
    @commission = Commission.find(params[:id])
  end
end
