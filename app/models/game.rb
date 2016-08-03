class Game < ActiveRecord::Base
  belongs_to :white_user, class_name: 'User'
  belongs_to :black_user, class_name: 'User'
  has_many :moves
  has_many :pieces

  # Query the database for games that don't have a black player
  scope :open_games, -> { where(black_user_id: nil) }
  after_create :populate_board!

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
