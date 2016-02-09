class ProfilesController < ApplicationController
  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to edit_profile_path, notice: "profile updated"
    else
      redirect_to edit_profile_path, notice: "error"
    end
  end
end
private
  def user_params
    if admin?
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
    else
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  end
