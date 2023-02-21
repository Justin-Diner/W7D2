class UsersController < ApplicationController

	def index 
		@users = User.all
		 render :index 
	end

	def create 
		@user = User.new(user_params)
		if @user.save 
			redirect_to user_url(@user)
		else 
			render :new 
		end
	end

	def new 
		@user = User.new 
		render :new 
	end

	def show 
		@user = User.find(params[:id])
		render :show 
	end

	def edit 
		@user = User.find(params[:id])
		render :edit 
	end

	def update 
		@user = User.find(params[:id])
		if @user.update(user_params)
			redirect_to user_url(@user)
		else 
			puts @user.errors.full_messages
			render :edit 
		end
	end

	def user_params 
		params.require(:user).permit(:email, :session_token, :password_digest)
	end
end