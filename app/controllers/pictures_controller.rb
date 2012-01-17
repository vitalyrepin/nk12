class PicturesController < ApplicationController
  def index
    @pictures = Picture.all
    render :json => @pictures.collect { |p| p.to_jq_upload }.to_json
  end

  def create
    @picture = Picture.new(params[:picture])
    if @picture.save
      render :json => [@picture.to_jq_upload].to_json
    else 
      render :json => [{:error => "custom_failure"}], :status => 304
    end
  end

  # def destroy
  #   @picture = Picture.find(params[:id])
  #   @picture.destroy
  #   render :json => true
  # end
end
