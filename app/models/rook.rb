class Rook < Piece

  def valid_move?(destination_x, destination_y)
    return false if obstructed?(destination_x, destination_y) != false
    
    if super && (current_position_x == destination_x || current_position_y == destination_y)
      return true
    else
      return false
    end
  end

end
