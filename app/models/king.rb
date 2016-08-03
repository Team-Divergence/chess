class King < Piece
  def is_valid_move?(move_to_x, move_to_y)
    # Check to see if new position is on board
    if move_to_x < 0 || move_to_x > 7 || move_to_y < 0 || move_to_y > 7
      return false
    else
      # King can move 1 square in any direction
      if (current_position_x - move_to_x).abs <= 1 && (current_position_y - move_to_y).abs <= 1
        return true
      else
        false
      end
    end
  end
end
