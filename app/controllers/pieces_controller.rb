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
          if @game.check?(@piece.color)
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
end
