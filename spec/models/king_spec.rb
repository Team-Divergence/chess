require 'rails_helper'

RSpec.describe King, type: :model do
  game = FactoryGirl.create(:game)
  king = FactoryGirl.create(:king, current_position_x: 0, current_position_y: 3, color: 'black', game: game)
  king2 = FactoryGirl.create(:king, current_position_x: 4, current_position_y: 4)
  describe 'valid_move?' do
    it 'should return false if move_to square is off board' do
      expect(king.valid_move?(9, 9)).to eq(false)
    end

    it 'should return false if move_to square is same square' do
      expect(king.valid_move?(0, 3)).to eq(false)
    end

    it 'should return false if move_to square contains piece with same color' do
      expect(king.valid_move?(0,0)).to eq(false)
    end

    it 'should return false when a move is out of range for King' do
      expect(king.valid_move?(0, 5)).to eq(false)
    end

    it 'should return true when a move is in range for King' do
      expect(king2.valid_move?(4, 5)).to eq(true)
    end
  end

  castle_game = FactoryGirl.create(:game)
  king = Piece.find_by(current_position_x: 4, current_position_y: 0, game: castle_game)
  king3 = Piece.find_by(current_position_x: 4, current_position_y: 7, game: castle_game)
  describe 'castling' do
    
    it 'should return true if castling is valid' do
      # Kingside top
      expect(king.castling?(6, 0)).to eq(true)

      #kingside bottom
      expect(king3.castling?(6, 7)).to eq(true)

      # Queenside top
      expect(king.castling?(2, 0)).to eq(true)

      # Queenside bottom
      expect(king3.castling?(2, 7)).to eq(true)
    end

    it 'should return false if castling is invalid' do
      # Kingside top
      expect(king.castling?(7, 0)).to eq(false)
      expect(king.castling?(5, 0)).to eq(false)
      #Kingside bottom
      expect(king3.castling?(7, 7)).to eq(false)
      expect(king3.castling?(5, 7)).to eq(false)

      #Queenside top
      expect(king.castling?(1, 0)).to eq(false)
      expect(king.castling?(3, 0)).to eq(false)
      #Queenside bottom
      expect(king3.castling?(1, 7)).to eq(false)
      expect(king3.castling?(3, 7)).to eq(false)
    end
  end
end
