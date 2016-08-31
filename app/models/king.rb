class King < Piece
  def valid_move?(move_to_x, move_to_y)
    # Range of king is <= 1 unless the king is castlling
    if super && (proper_length?(move_to_x, move_to_y) || (castling?(move_to_x, move_to_y) && !obstructed(move_to_x, move_to_y)))
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

  # determine if king can move himself out of check
  def can_move_out_of_check?
    starting_x = current_position_x
    starting_y = current_position_y
    success = false
    ((current_position_x - 1)..(current_position_x + 1)).each do |x|
      ((current_position_y - 1)..(current_position_y + 1)).each do |y|
        update_attributes(current_position_x: x, current_position_y: y) if valid_move?(x, y)
        # if game.check?(color) comes up false,
        # even once, assign  true
        success = true unless game.check?(color)
        # reset any attempted moves
        update_attributes(current_position_x: starting_x, current_position_y: starting_y)
      end
    end
    success
  end


  def castling?(x, y)
    # if king is currently in check, castling is false
    # if king would castle in to check, castling is false
    # if king would castle through check, castling is false
    # if king has moved or rook has moved, castling is false
    x_difference = current_position_x - x

    # Queenside
    if x < self.current_position_x
      queenside_rook = Piece.find_by(type: 'Rook', current_position_x: 0, current_position_y: y)
      if queenside_rook.present?
        # if king and rook havn't moved
        if self.has_moved == false && queenside_rook.has_moved == false
          # king moves excatly 2 squares horizontally
          if x_difference.abs == 2 && y == current_position_y
            return true
          else
            return false
          end
        end
      else
      end
    end

    if x > self.current_position_x
      kingside_rook = Piece.find_by(type: 'Rook', current_position_x: 7, current_position_y: y)
      # if king and rook havn't moved
      if kingside_rook.present?
        if self.has_moved == false && kingside_rook.has_moved == false
          # king moves excatly 2 squares horizontally
          if x_difference.abs == 2 && y == current_position_y
            return true
          else
            return false
          end
        end
      else
      end
    end
  end
end
