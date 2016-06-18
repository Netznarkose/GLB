class ProfilesController < ApplicationController
  before_action :protect_from_non_currents_and_guests, only: [:edit, :update]

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to edit_profile_path, notice: 'profile updated'
    else
      redirect_to edit_profile_path, notice: 'Access denied!'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def protect_from_non_currents_and_guests
    if !current_user || current_user.guest?
      redirect_to root_path, notice: 'Access denied!'
    end
  end
end
