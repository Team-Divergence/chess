class Piece < ActiveRecord::Base
  belongs_to :game
  has_many :moves

  def valid_move?(move_to_x, move_to_y)
    difference_x = move_to_x - current_position_x
    difference_y = move_to_y - current_position_y

    move_to_piece = Piece.find_by(current_position_x: move_to_x, current_position_y: move_to_y, game: game)
    #check move is on the board
    if move_to_x < 0 || move_to_x > 7 || move_to_y < 0 || move_to_y > 7
      return false
    #check move is not to the same square
    elsif current_position_x == move_to_x && current_position_y == move_to_y
      return false
    elsif move_to_piece.present? && self.color == move_to_piece.color
      return false
    else
      return true
    end
  end

  # Possibly needs refactoring - shares common code with is_valid_move
  def move_to!(new_x, new_y)
    piece = self
    # variable to see if space is occupied
    is_space_occupied = Piece.find_by(current_position_x: new_x, current_position_y: new_y)

    # if space is occupied and it's a different color
    if is_space_occupied && is_space_occupied.color != piece.color
      is_space_occupied.destroy()
      piece.update_attributes(current_position_x: new_x, current_position_y: new_y, has_moved: true)
    # if space is occupied and it's the same color
    # actutally already checked above in valid_move?
    # elsif is_space_occupied && is_space_occupied.color == piece.color
    #   return "Error, You can't capture your own piece."
    # # if it's unoccupied
    else
      piece.update_attributes(current_position_x: new_x, current_position_y: new_y, has_moved: true)
    end
  end


  def image
    "#{color}-#{type.downcase}.png"
  end

=begin
  def is_obstructed?(x, y)
    piece = self
    current_x = piece.current_position_x
    current_y = piece.current_position_y
    x_difference = current_x - x
    y_difference = current_y - y
    all_pieces = Game.find(game_id).pieces
    # (3, 4) -> (1, 3)
    # x_difference: 2
    # y_difference: 1
    if (x_difference.abs != y_difference.abs) && (x_difference != 0) && (y_difference != 0)
      # puts "Invalid input"
      # flash.now[:alert] = 'Invalid input'
      return
    end

    check = false
    new_x = x
    new_y = y

    while !check
      # starting from the destination, moves through
      # each square in between the destination and current

      if new_x > current_x
        new_x -= 1
      elsif new_x < current_x
        new_x += 1
      end

      if new_y > current_y
        new_y -= 1
      elsif new_y < current_y
        new_y += 1
      end

      # if at current position stop looping
      if (new_x == current_x) && (new_y == current_y)
        check = true
      # else, check position of each piece on the board
      # to see if it is obstructing
      else
        all_pieces.each do |p|
          if (p.current_position_x == new_x) && (p.current_position_y == new_y)
            return true
          end
        end
      end

    end

    false
  end
=end

  def obstructed?(move_to_x, move_to_y)
    # we need to know the squares in between
    difference_x = (move_to_x - self.current_position_x) # .abs
    difference_y = (move_to_y - self.current_position_y) # .abs
    count = 1

    # vertical
    if difference_x == 0
      while count < difference_y.abs
        if difference_y < 0
          piece = Piece.find_by(current_position_x: move_to_x, current_position_y: move_to_y + count)
          if piece.present?
            return true
          else
            count += 1
          end
        else
          piece = Piece.find_by(current_position_x: move_to_x, current_position_y: move_to_y - count)
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
          piece = Piece.find_by(current_position_x: move_to_x - count, current_position_y: move_to_y)
          if piece.present?
            return true
          else
            count += 1
          end
        else
          piece = Piece.find_by(current_position_x: move_to_x + count, current_position_y: move_to_y)
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

    # bottom left moving up and right
    if difference_x.abs == difference_y.abs
      while count < difference_x.abs
        if difference_x > 0 && difference_y < 0
          piece = Piece.find_by(current_position_x: move_to_x - count, current_position_y: move_to_y + count)
          if piece.present?
            return true
          else
            count += 1
            false
          end

        # bottom right moving up and left
        elsif difference_x < 0 && difference_y < 0
          piece = Piece.find_by(current_position_x: move_to_x + count, current_position_y: move_to_y + count)
          if piece.present?
            return true
          else
            count += 1
            false
          end
        #top left moving down and right
        elsif difference_x > 0 && difference_y > 0
            piece = Piece.find_by(current_position_x: move_to_x - count, current_position_y: move_to_y - count)
            if piece.present?
              return true
            else
              count += 1
              false
            end
        # top right moving down and left
        elsif difference_x < 0 && difference_y > 0  # maybe should just be else
          piece = Piece.find_by(current_position_x: move_to_x + count, current_position_y: move_to_y - count)
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
