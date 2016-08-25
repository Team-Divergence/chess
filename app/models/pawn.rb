class Pawn < Piece
  def valid_move?(move_to_x, move_to_y)
    return false unless super
    return false if current_position_x != move_to_x unless capture?(move_to_x, move_to_y)
    if has_moved
      if color == 'white' && (current_position_y - move_to_y) == 1
        true
      elsif color == 'black' && (move_to_y - current_position_y) == 1
        true
      else
        false
      end 
    else
      if color == 'white' && (1..2) === (current_position_y - move_to_y)
        true
      elsif color == 'black' && (1..2) === (move_to_y - current_position_y) 
        true
      else
        false      
      end
    end      
  end

  def capture?(move_to_x, move_to_y)
    capture_piece = game.pieces.find_by(current_position_x: move_to_x, current_position_y: move_to_y)
    if capture_piece && capture_piece.color != color
      if (current_position_x - move_to_x) == 1 || (current_position_x - move_to_x) == -1
        true
      else
        false
      end
    end
  end
end

