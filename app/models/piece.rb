class Piece < ActiveRecord::Base
  belongs_to :game
  has_many :moves

  def is_valid_move?(move_to_x, move_to_y)
    move_to_piece = Piece.find_by(current_position_x: move_to_x, current_position_y: move_to_y)   
    #check move is on the board
    if move_to_x < 0 || move_to_x > 7 || move_to_y < 0 || move_to_y > 7
      return false
    #check move is not to the same square
    elsif current_position_x == move_to_x && current_position_y == move_to_y
      return false
    #check move is not to square that contains player's own piece
    elsif move_to_piece.present? && self.color == move_to_piece.color 
      return false
    else
      return true
    end
  end

  def move_to!(new_x, new_y)
    piece = self
    # variable to see if space is occupied
    is_space_occupied = Piece.find_by(current_position_x: new_x, current_position_y: new_y)

    # if space is occupied and it's a different color
    if is_space_occupied && is_space_occupied.color != piece.color
      is_space_occupied.destroy()
      piece.update_attributes(current_position_x: new_x, current_position_y: new_y)
    else
      puts "Error, You can't capture your own piece."
    end
  end


  def symbol
    "#{color}-#{type.downcase}.png"
  end

  def is_obstructed?(x, y)
    piece = self
    current_x = piece.current_position_x
    current_y = piece.current_position_y
    x_difference = current_x - x
    y_difference = current_y - y
    all_pieces = Game.find(game_id).pieces

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
end
