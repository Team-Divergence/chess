class King < Piece

  def castle_move
    update_attributes(current_position_x: @new_king_x, current_position_y: current_position_y, has_moved: true)
    @castle_rook.update_attributes(current_position_x: @new_rook_x, current_position_y: current_position_y, has_moved: true)
  end

  def valid_move?(move_to_x, move_to_y)
    # Range of king is <= 1 unless the king is castlling
    if super && (proper_length?(move_to_x, move_to_y) || (castling?(move_to_x, move_to_y) && !obstructed?(move_to_x, move_to_y)))
      return true
    else
      return false
    end
  end

  def proper_length?(move_to_x, move_to_y)
    x_diff = (current_position_x - move_to_x).abs
    y_diff = (current_position_y - move_to_y).abs

    (x_diff <= 1) && (y_diff <=1)
  end

  def castling?(x, y)
    x_difference = current_position_x - x

    return false unless has_moved == false
    return false unless x_difference.abs == 2
    return false unless y == current_position_y

    # Queenside
    if x < self.current_position_x
      @castle_rook = get_rook_for_castle('Queen')
      @new_king_x = 2
      @new_rook_x = 3
    else
      # Kingside
      @castle_rook = get_rook_for_castle('King')
      @new_king_x = 6
      @new_rook_x = 5
    end

    return false if @castle_rook.nil?

    return false unless @castle_rook.has_moved == false

    true
  end

  def move_to!(x, y)
    if valid_move?(x, y) && castling?(x, y)
      castle_move
    else
      super(x, y)
    end
  end

  def get_rook_for_castle(side)
    case side
    when 'King'
      game.pieces.find_by(
        type: 'Rook',
        current_position_x: 7,
        current_position_y: current_position_y
      )

    when 'Queen'
      game.pieces.find_by(
        type: 'Rook',
        current_position_x: 0,
        current_position_y: current_position_y
      )

    else
      return nil
    end
  end
end
