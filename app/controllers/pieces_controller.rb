class PiecesController < ApplicationController
  before_action :authenticate_user!

  before_filter do
    @piece = Piece.find(params[:id])
    @game = @piece.game
  end

  def update
    Piece.transaction do
      x = params[:piece][:current_position_x].to_i
      y = params[:piece][:current_position_y].to_i
      if @piece.valid_move?(x, y)
        # we also have to perform any capture that happens from this move, before checking check?
        @piece.move_to!(x, y)
        if @game.check?(@piece.color) || !update_firebase(@piece, x, y)
          fail ActiveRecord::Rollback
        end
        render json: nil, status: :ok 
      else
        render text: 'Invalid move!', status: :unauthorized
      end
    end
    rescue ActiveRecord::Rollback
      render text: 'Invalid move!', status: :unauthorized
  end


  private

  def piece_params
    params.require(:piece).permit(:current_position_x, :current_position_y)
  end

  def update_firebase(piece, x, y)
    base_uri = "https://divergence-chess.firebaseio.com/"
    firebase = Firebase::Client.new(base_uri)
    i = 0
    while i < 3
      f = firebase.set("pieces/#{piece.id}", current_position_x: x, current_position_y: y)
      return true if f.success?
      i += 1
    end
    return false
  end

end
