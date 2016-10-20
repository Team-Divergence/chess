class Pawn < Piece

  def can_promote?(y)
    if color == 'white'
      y == 0
    else
      y == 7
    end
  end

  def move_to!(x, y)
    return false unless valid_move?(x, y)
    capture_piece = game.pieces.find_by(current_position_x: x, current_position_y: y)

    if can_promote?(y) && capture_piece.present?
      capture_piece.destroy()
      promotion(x, y)
    elsif can_promote?(y)
      promotion(x, y)
    else
      super(x, y)
    end
  end

  def promotion(x, y)
     update_attributes(
      current_position_x: x,
      current_position_y: y,
      type: 'Queen',
      has_moved: true,
      color: color,
    )
    update_firebase(x, y, 'Queen')
    game.switch_turns
  end

  def valid_move?(move_to_x, move_to_y)

    return false unless super

    # check pawn is moving forward on the board (depending on color)
    # and if it hasnt moved, it can move 2 forward
    if has_moved
      if color == 'white' && (current_position_y - move_to_y) == 1
        #
      elsif color == 'black' && (move_to_y - current_position_y) == 1
        #
      else
        return false
      end
    else
      if color == 'white' && (1..2) === (current_position_y - move_to_y)
        #
      elsif color == 'black' && (1..2) === (move_to_y - current_position_y)
        #
      else
        return false
      end
    end

    # check if we are moving straight up the board and nothing is in the way
    if current_position_x == move_to_x
      if capture?(move_to_x, move_to_y)
        return false
      else
        return true
      end
    else
      # check if we are moving diagonally one sqaure across and one sqaure up
      if (current_position_x - move_to_x).abs == 1 &&
         (current_position_y - move_to_y).abs == 1
        # and check there is an opponent piece there
        if capture?(move_to_x, move_to_y)
          return true
        else
          return false
        end
      else
        return false
      end
    end

  end
end
