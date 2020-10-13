class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      @user.complete if @user.state == 'new'
      flash[:success] = "Profile updated!"
      redirect_to user_path(current_user)
    else
      flash.now[:danger] = @user.errors.full_messages.to_sentence
      render action: :edit
    end
  end

  private
  def set_current_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :surname, :birthday, :sex, :country, :city, :phone, :organization_name, :organization_address, :field_of_activity, :start_hour, :end_hour, :holiday, :slot_size)
  end



end
