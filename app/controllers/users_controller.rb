class UsersController < ApplicationController
	around_action :catch_not_found

	before_action :signed_in_user, 	only: [:current_user_home]
	before_action :private?, 				only: [:show, :edit, :update]
	before_action :correct_user?, 	only: [:edit, :update]

	def show
		@user  = User.find(params[:id])
		@posts = @user.posts
		@post = current_user.posts.build if current_user == @user
	end

	def edit
		@user = User.find(params[:id])
		@posts = @user.posts
	end

	def update
		@user = User.find(params[:id])
		@posts = @user.posts
		if @user.update_attributes(user_params)
			redirect_to @user
		else
			render 'edit'
		end
	end

	def current_user_home
	  redirect_to current_user
	end

	private  

	def user_params
		params.require(:user).permit(:name, :email, :description, :private)
	end

	def correct_user?
		@user = User.find(params[:id])
		if current_user != @user
			redirect_to @user
		end
	end

	def private?
		@user  = User.find(params[:id])
		if @user.private && current_user != @user
			redirect_to fail_path
		end
	end

	def catch_not_found
	  yield
	rescue ActiveRecord::RecordNotFound
	  redirect_to fail_path
	end

end