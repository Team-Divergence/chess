class PiecesController < ApplicationController
  before_action :authenticate_user!

  before_filter do
    @piece = Piece.find(params[:id])
    @game = @piece.game
  end

  def update
    old_x = @piece.current_position_x
    old_y = @piece.current_position_y
    x = params[:piece][:current_position_x].to_i
    y = params[:piece][:current_position_y].to_i
    if @piece.valid_move?(x, y)
      @piece.update_attributes(current_position_x: x, current_position_y: y)
      if @game.check?(@piece.color)
        @piece.update_attributes(current_position_x: old_x, current_position_y: old_y)
        return render text: 'Invalid move!', status: :unauthorized
      end
      @piece.update_attributes(current_position_x: old_x, current_position_y: old_y)
      @piece.move_to!(x, y)
      base_uri = "https://divergence-chess.firebaseio.com/"
      firebase = Firebase::Client.new(base_uri)
      firebase.set("pieces/#{@piece.id}", current_position_x: x, current_position_y: y)
      render json: nil, status: :ok
      # redirect_to game_path(@game)
    else
      render text: 'Invalid move!', status: :unauthorized
    end
  end

  private

  def piece_params
    params.require(:piece).permit(:current_position_x, :current_position_y)
  end
end
