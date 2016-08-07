class King < Piece
  def is_valid_move?(move_to_x, move_to_y) 
    
    if super == true && (current_position_x - move_to_x).abs <= 1 && (current_position_y - move_to_y).abs <= 1
      return true
    else
      return false
    end

  end
end
