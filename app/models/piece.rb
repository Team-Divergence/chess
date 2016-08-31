class Piece < ActiveRecord::Base
  belongs_to :game


  def valid_move?(move_to_x, move_to_y)

    move_to_piece = game.pieces.find_by(current_position_x: move_to_x, current_position_y: move_to_y)
    #check move is on the board
    if move_to_x < 0 || move_to_x > 7 || move_to_y < 0 || move_to_y > 7
      return false
    #check move is not to the same square
    elsif current_position_x == move_to_x && current_position_y == move_to_y
      return false
    #check move is not to square with piece of same color on it
    elsif move_to_piece.present? && self.color == move_to_piece.color
      return false
    else
      return true
    end
  end

  def capture?(move_to_x, move_to_y)
    capture_piece = game.pieces.find_by(current_position_x: move_to_x, current_position_y: move_to_y)
    capture_piece && capture_piece.color != color
  end

  def move_to!(move_to_x, move_to_y)
    unless valid_move?(move_to_x, move_to_y)
      raise 'Not valid move!'
    end
    # variable to see if space is occupied
    capture_piece = game.pieces.find_by(current_position_x: move_to_x, current_position_y: move_to_y)
    # if space is occupied and it's a different color
    if capture?(move_to_x, move_to_y)
      capture_piece.destroy()
    end
      update_attributes(current_position_x: move_to_x, current_position_y: move_to_y, has_moved: true)
      game.switch_turns
  end

  def image
    "#{color}-#{type.downcase}.png"
  end


  def obstructed?(move_to_x, move_to_y)
    # we need to know the squares in between
    difference_x = (move_to_x - self.current_position_x) # .abs
    difference_y = (move_to_y - self.current_position_y) # .abs
    count = 1

    # vertical
    if difference_x == 0
      while count < difference_y.abs
        if difference_y < 0
          piece = game.pieces.find_by(current_position_x: move_to_x, current_position_y: move_to_y + count)
          if piece.present?
            return true
          else
            count += 1
          end
        else
          piece = game.pieces.find_by(current_position_x: move_to_x, current_position_y: move_to_y - count)
          if piece.present?
            return true
          else
            count += 1
          end
        end
        false
      end
    end

    # horizontal
    if difference_y == 0
      while count < difference_x.abs
        if difference_x < 0
          piece = game.pieces.find_by(current_position_x: move_to_x + count, current_position_y: move_to_y)
          if piece.present?
            return true
          else
            count += 1
          end
        else
          piece = game.pieces.find_by(current_position_x: move_to_x - count, current_position_y: move_to_y)
          if piece.present?
            return true
          else
            count += 1
          end
        end
        false
      end
    end

    # diagonal
    if difference_x.abs == difference_y.abs
      while count < difference_x.abs
        # bottom left moving up and right
        if difference_x > 0 && difference_y < 0
          piece = game.pieces.find_by(current_position_x: move_to_x - count, current_position_y: move_to_y + count)
          if piece.present?
            return true
          else
            count += 1
            false
          end

        # bottom right moving up and left
        elsif difference_x < 0 && difference_y < 0
          piece = game.pieces.find_by(current_position_x: move_to_x + count, current_position_y: move_to_y + count)
          if piece.present?
            return true
          else
            count += 1
            false
          end
        #top left moving down and right
        elsif difference_x > 0 && difference_y > 0
            piece = game.pieces.find_by(current_position_x: move_to_x - count, current_position_y: move_to_y - count)
            if piece.present?
              return true
            else
              count += 1
              false
            end
        # top right moving down and left
        elsif difference_x < 0 && difference_y > 0  # maybe should just be else
          piece = game.pieces.find_by(current_position_x: move_to_x + count, current_position_y: move_to_y - count)
          if piece.present?
            return true
          else
            count += 1
            false
          end
        end
      end
    end
    false
  end
end
