class Knight < Piece
  def valid_move?(destination_x, destination_y)
    return (destination_x - current_position_x).abs + (destination_y - current_position_y).abs == 3
  end
end
