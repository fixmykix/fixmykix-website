module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_with_token!, only: [:update, :destroy]
      respond_to :json

      def index 
        render json: User.all.reverse_order
      end 

      def show 
        render json: User.find(params[:id])
      end 

      def create 
        user = User.new(user_params)
        if user.save 
          render json: user, status: 201, location: [:api, user]
        else 
          render json: { errors: user.errors }, status: 422
        end
      end 

      def update 
        user = current_user
        if user.update(user_params)
          render json: user, status: 200, location: [:api, user]
        else 
          render json: { errors: user.errors }, status: 422
        end 
      end

      def destroy 
        user = current_user
        if user.destroy
          head 204
        else 
          head 401
        end
      end 

      private 

      def user_params 
        params.require(:user).permit(:email, :password, :password_confirmation)
      end 
    end
  end 
end

