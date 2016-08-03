class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @games = Game.open_games
  end
end
