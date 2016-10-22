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

      unless @game.turn == current_user.id
        response = 'Not your turn' + ' - ' + @game.turn_color + ' turn'
        return render text: response, status: :unauthorized
      end
      unless @piece.color.capitalize == @game.turn_color
        response = 'Invalid move!' + ' - ' + @game.turn_color + ' turn'
        return render text: response, status: :unauthorized
      end
      if @piece.valid_move?(x, y)
        # we also have to perform any capture that happens from this move, before checking check?
        @piece.move_to!(x, y)
        if @game.check?(@piece.color) || !@piece.update_firebase(x, y)
          fail ActiveRecord::Rollback
        end
        response = @game.turn_color + ' turn'
        render text: response, status: :ok
      else
        response = 'Invalid move!' + ' - ' + @game.turn_color + ' turn'
        render text: response, status: :unauthorized
      end
    end
    rescue ActiveRecord::Rollback
      response = 'Invalid move!' + ' - ' + @game.turn_color + ' turn'
      render text: response, status: :unauthorized
  end


  private

  def piece_params
    params.require(:piece).permit(:current_position_x, :current_position_y)
  end

end
