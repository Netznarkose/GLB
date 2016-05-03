class UsersController < ApplicationController
  before_action :find_user, only: [:show, :update, :destroy]
  before_action :protect_from_non_admins, except: :edit
  before_action :protect_from_non_currents, only: [:edit, :update]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'Mitarbeiter erfolgreich erstellt!' }
        format.json { render json: @user, role: :created, location: @user }
      else
        format.html { redirect_to new_user_path, notice: @user.errors.messages.values.flatten.uniq.join('<br/>') }
        format.json { render json: @user.errors, role: :unprocessable_entity } 
      end
    end
  end

  # GET /users/1/edit
  def edit
    if current_user?
      redirect_to edit_profile_path(@user) 
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_path, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to edit_user_path(@user), notice: @user.errors.messages.values.flatten.uniq.join('<br />') }
        format.json { render json: @user.errors, role: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    respond_to do |format|
      @user.destroy
      format.html { redirect_to users_url, notice: "User #{@user.name} was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end

  def find_user
    @user = User.find(params[:id])
  end

  def protect_from_non_admins
    handle_unauthorized unless admin?
  end

  def protect_from_non_currents
    handle_unauthorized unless current_user?
  end

  def handle_unauthorized
    unless admin?
      respond_to do |format|
        format.html do
          flash[:notice] = 'Access denied!'
          redirect_to root_path
        end
        format.json { render nothing: true, status: :unauthorized }
      end
    end
  end
end
