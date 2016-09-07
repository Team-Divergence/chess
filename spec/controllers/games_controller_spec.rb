require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe 'games#update' do
    it 'should successfully allow a user to join an open game' do
      user = FactoryGirl.create(:user)
      sign_in user

      g = Game.create(name: 'Divergence')      
      patch :update, id: g.id, game: {black_user_id: user}       
      expect(response).to redirect_to game_path(g)
    end

    it 'should return a not allowed error if there is already a second player' do
      user = FactoryGirl.create(:user)
      sign_in user

      g = Game.create(name: 'Divergence') 
      patch :update, id: g.id, game: {black_user_id: user}
      expect(g.black_user_id).to eq nil 

      patch :update, id: g.id, game: {black_user_id: user}     
      expect(response).to have_http_status(:forbidden)
    end    
  end

  describe 'game#show action' do
    it 'should successfully show the page if the game is found' do
      user = FactoryGirl.create(:user)
      sign_in user

      g = Game.create(name: 'Divergence')
      get :show, id: g.id
      expect(response).to have_http_status(:success)
    end    
  end  

  describe 'games#create action' do
    it 'should require users to be logged in' do
      post :create, game: { name: 'Divergence'}
      expect(response).to redirect_to new_user_session_path
    end

    it 'should successfully create a new game in our database' do
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, game: { name: 'Divergence'}
      expect(response).to redirect_to user_path(user)

      game = Game.last
      expect(game.name).to eq('Divergence')
      expect(game.white_user).to eq(user)
    end

    it 'should properly deal with validation errors' do
      user = FactoryGirl.create(:user)
      sign_in user

      game_count = Game.count
      post :create, game: {name: '' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(game_count).to eq Game.count
    end
  end 

  describe 'games#new action' do 
    it 'should require users to be logged in' do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it 'should successfully show the new form' do
      user = FactoryGirl.create(:user)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end
end
