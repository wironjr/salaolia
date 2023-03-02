class UsersController < ApplicationController
	before_action :require_logged_in_user

def index
	@user_all = User.all
end

def new
  @user = User.new
end

def json_teste
	@user = User.where(nome: params[:nome])
	render json: JSON.parse(@user.to_json)
end

def create
	@user = User.new(user_params)
	@user.nome = @user.nome.downcase
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
