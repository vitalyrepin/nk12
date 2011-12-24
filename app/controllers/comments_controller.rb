class CommentsController < ApplicationController

  def create
    if commission = Commission.find_by_id(params[:commission_id])
      @comment = commission.comments.build(:email=>params[:email], :fio=>params[:fio], :body=>params[:body],:violation=>params[:violation],:commission_id=>params[:commission_id])
    end
    respond_to do |format|
      if defined? @comment and @comment.save
        format.json { render json: {status: "created"}}
      else
        format.json { render json: {status: "not_created"} }
      end
    end
  end

end
