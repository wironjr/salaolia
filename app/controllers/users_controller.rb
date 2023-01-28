class UsersController < ApplicationController
	before_action :require_logged_in_user
	
def new
  @user = User.new
  @user_all = User.all
end

def create
	@user = User.new(user_params)
	if @user.save
		flash[:success] = 'Usuário criado com sucesso'
		redirect_to root_url
	else
		render 'new'
	end
end

private
	def user_params
		params.require(:user).permit(:nome, :password, :password_confirmation)
	end
	
end
