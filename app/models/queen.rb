class Queen < Piece
  def valid_move? (position_x, position_y)
    if is_obstructed(position_x, position_y)
      false
    else
      super &&
      ( #vertical
      current_position_x == position_x ||
      # horizontal
      current_position_y == position_y ||
      # diagonal
      (current_position_y - position_y).abs == (current_position_x - position_x).abs)
    end
  end
end
