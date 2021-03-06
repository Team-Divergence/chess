class Piece < ActiveRecord::Base
  belongs_to :game
  has_many :moves

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
    if en_passant?(move_to_x, move_to_y)
      capture_piece = game.moves.last.piece
    else
      capture_piece = game.pieces.find_by(current_position_x: move_to_x, current_position_y: move_to_y)
    end
    capture_piece && capture_piece.color != color
  end

  def move_to!(move_to_x, move_to_y)
    unless valid_move?(move_to_x, move_to_y)
      raise 'Not valid move!'
    end
    # variable to see if space is occupied
    if en_passant?(move_to_x, move_to_y)
      capture_piece = game.moves.last.piece
    else
      capture_piece = game.pieces.find_by(current_position_x: move_to_x, current_position_y: move_to_y)
    end
    # if space is occupied and it's a different color
    if capture?(move_to_x, move_to_y)
      capture_piece.destroy()
      capture_piece.remove_from_firebase
    end
      update_attributes(current_position_x: move_to_x, current_position_y: move_to_y, has_moved: true)
      game.switch_turns
  end

  def image
    "#{color}-#{type.downcase}.png"
  end

  def en_passant?(move_to_x, move_to_y)
    if last_move = game.moves.last
      last_move.piece.type == "Pawn" && last_move.end_position_y == current_position_y && (last_move.start_position_y - last_move.end_position_y).abs == 2
    else
      false
    end
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

  def update_firebase(x, y, check, promote=false)
    base_uri = "https://divergence-chess.firebaseio.com/"
    firebase = Firebase::Client.new(base_uri)
    i = 0
    while i < 3
      f = firebase.set("pieces/#{id}", current_position_x: x, current_position_y: y, p_color: color, promoted: promote, check: check)
      return true if f.success?
      i += 1
    end
    return false
  end

  def remove_from_firebase
    base_uri = "https://divergence-chess.firebaseio.com/"
    firebase = Firebase::Client.new(base_uri)
    i = 0
    while i < 3
      f = firebase.delete("pieces/#{id}")
      return true if f.success?
      i += 1
    end
    return false
  end

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
