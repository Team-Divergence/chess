class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @user = User.find(params[:id])
    @games = Game.open_games
    @games_won = Game.where(winning_user_id: @user)
  end
end
