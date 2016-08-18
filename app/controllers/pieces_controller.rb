class PiecesController < ApplicationController
  before_action :authenticate_user!

  def show
    @piece = Piece.find(params[:id])
    @game = @piece.game
  end

  def update
    @piece = Piece.find(params[:id])
    @game = @piece.game
    x = params[:piece][:current_position_x].to_i
    y = params[:piece][:current_position_y].to_i
    if @piece.valid_move?(x, y)
      @piece.move_to!(x, y)
      render json: nil, status: :ok
      #redirect_to game_path(@game)
    else
      render text: 'Invalid move!', status: :unauthorized
    end
  end

  private

  def piece_params
     params.require(:piece).permit(:current_position_x, :current_position_y)
  end


end
