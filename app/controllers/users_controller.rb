class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @users = User.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  def new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'Mitarbeiter erfolgreich erstellt!' }
        format.json { render json: @user, role: :created, location: @user }
      else
        format.html { redirect_to new_user_path, notice: @user.errors.messages.values.flatten.uniq.join('<br/>') } # ?
        format.json { render json: @user.errors, role: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_path, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to edit_user_path(@user), notice: @user.errors.messages.values.flatten.uniq.join('<br />') } # ?
        format.json { render json: @user.errors, role: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @user.entries.any?
        @user.assign_remaining_entries_to_super_admin
        format.html { redirect_to users_url, notice: "User #{@user.name} was successfully deleted. Entries have been moved to Superadmin" }
      else
        format.html { redirect_to users_url, notice: "User #{@user.name} was successfully deleted." }
      end
      @user.destroy
      format.json { head :no_content }
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end
end
