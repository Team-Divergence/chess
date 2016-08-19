class Queen < Piece
  def valid_move?(position_x, position_y)
    if obstructed?(position_x, position_y)
      return false
    end

    if ((super == true) &&
      # vertical
      (current_position_x == position_x) ||
      # horizontal
      (current_position_y == position_y) ||
      # diagonal
      ((current_position_y - position_y).abs == (current_position_x - position_x).abs))
      return true
    end
    return false
  end
end
