class HomeController < ApplicationController
  def index
    @commissions = Commission.roots
  end
end
