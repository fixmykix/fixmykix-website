require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do

  describe "GET #index" do
    before(:each) do
      current_user = FactoryGirl.create :user
      request.headers['Authorization'] = current_user.auth_token
      4.times { FactoryGirl.create :order, user: current_user }
      get :index, params: { user_id: current_user.id } 
    end

    it "returns 4 order records from the user" do
      order_response = JSON.parse(response.body, symbolize_names: true)
      expect(order_response.size).to eql(4)
    end

    it { should respond_with 200 }
  end

  describe "GET #show" do
    before(:each) do
      current_user = FactoryGirl.create :user
      request.headers['Authorization'] = current_user.auth_token
      @product = FactoryGirl.create :product
      @order = FactoryGirl.create :order, user: current_user, product_ids: [@product.id]
      get :show, params: { user_id: current_user.id, id: @order.id }
    end
  
    it "returns the user order record matching the id" do
      order_response = JSON.parse(response.body, symbolize_names: true)
      expect(order_response[:id]).to eql @order.id
    end

    it "includes the total for the order" do
      order_response = JSON.parse(response.body, symbolize_names: true)
      expect(order_response[:total]).to eql @order.total
    end
  
    it "includes the products on the order" do
      order_response = JSON.parse(response.body, symbolize_names: true)
      expect(order_response[:products].size).to eql(1)
    end
  
    it { should respond_with 200 }
  end 

  describe "POST #create" do
    before(:each) do
      current_user = FactoryGirl.create :user
      request.headers['Authorization'] = current_user.auth_token
  
      product_1 = FactoryGirl.create :product
      product_2 = FactoryGirl.create :product
      order_params = { product_ids: [product_1.id, product_2.id] }
      post :create, params: {  user_id: current_user.id, order: order_params }
    end
  
    it "returns the just user order record" do
      order_response = JSON.parse(response.body, symbolize_names: true)
      expect(order_response[:id]).to be_present
    end
  
    it { should respond_with 201 }
  end
end
