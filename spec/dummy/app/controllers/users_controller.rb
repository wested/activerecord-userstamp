class UsersController < ApplicationController
  def edit
    @user = User.find(params[:id])
    render(inline: "<%= @user.name %>")
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(user_params)
    render(inline: "<%= @user.name %>")
  end

  def create
    fail
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
