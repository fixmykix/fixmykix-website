require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  
  before(:each) { request.headers['accept'] = "application/vnd.fixmykix.v1" }
  

  describe 'POST - create user' do 
    context 'has been successfully created' do 
      before(:each) do 
        @user_attributes = FactoryGirl.attributes_for(:user)
        post :create, params: { user: @user_attributes }
      end
      
      it 'should return 200 and append users to db' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql(@user_attributes[:email]) 
      end 

      it { should respond_with 201 }
    end 

    context 'when user is not successfully created' do 
      before(:each) do 
        invalid_user_attributes = {  password: '12345678', 
                                password_confirmation: '12345678' }

        post :create, params: { user: invalid_user_attributes }
      end 

      it 'should give an error' do 
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it 'should explain why user was not saved explicitly' do 
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include "can't be blank"
      end 

      it { should respond_with 422 }
    end 
  end 

  describe 'GET - get specific user show page,' do 
    before(:each) do 
      @user = FactoryGirl.create(:user) 
      get :show, params: { id: @user.id }
    end 

    it 'should return user info' do 
      user_response = JSON.parse(response.body, symbolize_names: true)

      expect(user_response[:email]).to eql(@user.email)
    end 
  end 

  describe 'PATCH - update specific user information' do 
    context 'when user is successfully updated' do
      before(:each) do 
        @user = FactoryGirl.create(:user)
        patch :update, params: { id: @user.id, user: { email: "abe@hello.com"} }
      end 

      it 'should update users email' do
        user_response = JSON.parse(response.body, symbolize_names: true) 
        expect(user_response[:email]).to eql("abe@hello.com")
      end 

      it { should respond_with 200 }
    end 

    context 'when user is not updated correctly' do 
      before(:each) do 
        @user = FactoryGirl.create(:user)
        patch :update, params: { id: @user.id, user: { email: "bademailformat.com"} }
      end 

      it 'should send an error message' do 
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end 

      it 'should send an error message' do 
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include 'is invalid'
      end 

      it { should respond_with 422}
    end 

    describe 'DELETE - delete user from database' do 
      context 'successful user deletion' do 
        before(:each) do 
          @user = FactoryGirl.create(:user)
          delete :destroy, params: { id: @user.id }
        end 

        it { should respond_with 204 }
      end 
    end 

  end 
end