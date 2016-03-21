class ProfilesController < ApplicationController
  def edit
    unless current_user
      redirect_to root_path, notice: 'Access denied!' 
    end
  end

  def update
    if current_user.update(user_params)
      redirect_to edit_profile_path, notice: "profile updated"
    else
      redirect_to edit_profile_path, notice: "error"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
