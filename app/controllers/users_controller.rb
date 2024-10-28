# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user! # ログイン必須

  def index
    @users = User.page(params[:page]).per(5).order(:id)
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user  # ここでリダイレクト
    else
      render :edit
    end
  end
end
