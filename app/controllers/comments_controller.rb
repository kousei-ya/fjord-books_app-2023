# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable
  before_action :set_comment, only: [:destroy]
  before_action :check_user_permission, only: %i[edit update destroy]

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      redirect_to @commentable, alert: t('controllers.common.alert_create', name: Comment.model_name.human)
    end
  end

  def destroy
    @comment.destroy
    redirect_to @commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)  
  end

  private

  def set_commentable
    if params[:report_id]
      @commentable = Report.find(params[:report_id])
    elsif params[:book_id]
      @commentable = Book.find(params[:book_id])
    end
  end

  def set_comment
    @comment = @commentable.comments.find(params[:id])
  end

  def check_user_permission
    unless @comment.user == current_user
      redirect_to @commentable, alert: t('controllers.common.error_not_authorized')
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
