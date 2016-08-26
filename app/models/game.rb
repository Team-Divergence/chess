class Game < ActiveRecord::Base
  validates :name, presence: true

  after_create :populate_board!
  after_create :set_default_turn

  belongs_to :white_user, class_name: 'User'
  belongs_to :black_user, class_name: 'User'
  has_many :pieces

  # Query the database for games that don't have a black player
  scope :open_games, -> { where(black_user_id: nil) }

  def set_default_turn
    update_attributes(turn: white_user_id)
  end
 
  def check?(color)
    king = pieces.find_by(type: 'King', color: color)
    if color == 'white'
      opponents = pieces.where(color: 'black').to_a
    else
      opponents = pieces.where(color: 'white').to_a
    end

    opponents.each do |piece|
      if piece.valid_move?(king.current_position_x, king.current_position_y)
        return true
      end
    end
    false
  end

  def populate_board!
    # Black Pieces
    (0..7).each do |i|
      Pawn.create(game_id: id, current_position_x: i, current_position_y: 1, color: :black)
    end

    Rook.create(game_id: id, current_position_x: 0, current_position_y: 0, color: :black)
    Rook.create(game_id: id, current_position_x: 7, current_position_y: 0, color: :black)

    Knight.create(game_id: id, current_position_x: 1, current_position_y: 0, color: :black)
    Knight.create(game_id: id, current_position_x: 6, current_position_y: 0, color: :black)

    Bishop.create(game_id: id, current_position_x: 2, current_position_y: 0, color: :black)
    Bishop.create(game_id: id, current_position_x: 5, current_position_y: 0, color: :black)

    Queen.create(game_id: id, current_position_x: 3, current_position_y: 0, color: :black)
    King.create(game_id: id, current_position_x: 4, current_position_y: 0, color: :black)

    # White Pieces
    (0..7).each do |i|
      Pawn.create(game_id: id, current_position_x: i, current_position_y: 6, color: :white)
    end

    Rook.create(game_id: id, current_position_x: 0, current_position_y: 7, color: :white)
    Rook.create(game_id: id, current_position_x: 7, current_position_y: 7, color: :white)

    Knight.create(game_id: id, current_position_x: 1, current_position_y: 7, color: :white)
    Knight.create(game_id: id, current_position_x: 6, current_position_y: 7, color: :white)

    Bishop.create(game_id: id, current_position_x: 2, current_position_y: 7, color: :white)
    Bishop.create(game_id: id, current_position_x: 5, current_position_y: 7, color: :white)

    Queen.create(game_id: id, current_position_x: 3, current_position_y: 7, color: :white)
    King.create(game_id: id, current_position_x: 4, current_position_y: 7, color: :white)
  end
end
