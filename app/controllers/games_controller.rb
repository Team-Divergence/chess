class GamesController < ApplicationController
  before_action :authenticate_user!

  def new
    @game = Game.new
  end

  def create
    @game = current_user.white_games.create(game_params)

    if @game.valid?
      redirect_to user_path(current_user)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @game = Game.find_by_id(params[:id])

    if @game.blank?
      return render text: 'Not Found :(', status: :not_found
    end
  end

  def update
    @game = Game.find(params[:id])

    if @game.black_user.present?
      return render text: 'Not Allowed', status: :forbidden
    else
      @game.update_attributes(black_user_id: current_user.id)
      redirect_to game_path(@game)
    end
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end
end
